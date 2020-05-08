//
//  Scanner+Selector.swift
//  
//
//  Created by Ben Spratling on 5/8/20.
//

import Foundation



extension Scanner {
	
	public func scanSelectorCombinator()->SelectorCombinator? {
		let originalLocation = scanLocation
		if scanString(",") != nil {
			scanLocation = originalLocation
			return nil//
		}
		if scanCharacters(from: .whitespacesAndNewlines) != nil {
			//try other characters
			if scanString(">") != nil {
				_ = scanCharacters(from: .whitespacesAndNewlines)
				return .child
			}
			if scanString("+") != nil {
				_ = scanCharacters(from: .whitespacesAndNewlines)
				return .adjacentSibling
			}
			if scanString("~") != nil {
				_ = scanCharacters(from: .whitespacesAndNewlines)
				return .generalSibling
			}
		}
		//if it was just a space,
		scanLocation = originalLocation
		if scanString(" ") != nil {
			return .descendant
		}
		let preCurlyLocation = scanLocation
		//nothing, just not whitespace or {
		if scanString("{") != nil || scanCharacters(from: .whitespacesAndNewlines) != nil {
			scanLocation = preCurlyLocation
			return nil
		}
		return .moreSpecific
	}
	
	
	func scanSelectorMain()->CSSSelectorMain? {
		let originalLocation = scanLocation
		_ = scanCharacters(from: .whitespacesAndNewlines)
		if scanString("*") != nil {
			return .universal
		}
		if scanString("#") != nil {
			guard let letters:String = scanCharacters(from: .alphanumerics) else {
				scanLocation = originalLocation
				return nil
			}
			return .id(letters)
		}
		if scanString(".") != nil {
			guard let letters:String = scanCharacters(from: .letters) else {
				scanLocation = originalLocation
				return nil
			}
			return .className(letters)
		}
		
		guard let letters:String = scanCharacters(from: .alphanumerics) else {
			scanLocation = originalLocation
			return nil
		}
		return .elementName(letters)
	}
	
	
	///call immediately after scanSelectorMain() with a non-nil result
	func scanSelectorAttributes()->CSSSelectorAttribute? {
		let originalLocation = scanLocation
		guard scanString("[") != nil else {
			return nil
		}
		guard let attrName:String = scanCharacters(from: .letters) else {
			scanLocation = originalLocation
			return nil
		}
		let postNamePosition = scanLocation
		guard let operatorString = scanCharacters(from: selectorAttributeOperatorCharacters) else {
			if scanString("]") != nil {
				return CSSSelectorAttribute(name: attrName, operatorAndValue: nil)
			} else {
				//fail
				scanLocation = originalLocation
				return nil
			}
		}
		guard let op =  CSSSelectorAttribute.AttributeOperator(rawValue: operatorString) else {
			scanLocation = originalLocation
			return nil
		}
		guard scanString("\"") != nil else {
			scanLocation = originalLocation
			return nil
		}
		guard let valueString:String = scanUpToString("\"") else {
			scanLocation = originalLocation
			return nil
		}
		return CSSSelectorAttribute(name: attrName, operatorAndValue: (op, valueString))
	}
	
	func scanSelector()->CSSSelector? {
		let originalLocation = scanLocation
		guard let selectorMain = scanSelectorMain() else {
			scanLocation = originalLocation
			return nil
		}
		let attributes = scanSelectorAttributes()
		return CSSSelector(main: selectorMain, attributes: attributes)
	}
	
	
	func scanSelectorGroup()->SelectorGroup? {
		let originalLocation = scanLocation
		_ = scanCharacters(from: .whitespacesAndNewlines)
		guard let firstSelector:CSSSelector = scanSelector() else {
			scanLocation = originalLocation
			return nil
		}
		//scan additional opertor / selector items
		var additionalSelectors:[(SelectorCombinator, CSSSelector)] = []
		while let combinator:SelectorCombinator = scanSelectorCombinator() {
			//it's ok to not get a combinator, but if we get a combinator we must get a selector
			guard let nextSelector:CSSSelector = scanSelector() else {
				scanLocation = originalLocation
				return nil
			}
			additionalSelectors.append((combinator, nextSelector))
		}
		return SelectorGroup(firstSelector: firstSelector, additionalSelectors: additionalSelectors)
	}
	
}


let selectorAttributeOperatorCharacters:CharacterSet = CharacterSet(charactersIn: "=~^$*|")
