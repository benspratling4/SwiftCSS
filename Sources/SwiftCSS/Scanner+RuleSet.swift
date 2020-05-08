//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/8/20.
//

import Foundation


let propertyNameCharacterSet:CharacterSet = CharacterSet.lowercaseLetters.union(CharacterSet(charactersIn: "-"))
let valueCharacterSet:CharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-.#%(), \n\t"))

extension Scanner {
	
	public func scanDeclaration()->Declaration? {
		let originalLocation = scanLocation
		//scan away white space
		_ = scanCharacters(from: .whitespacesAndNewlines)
		//scan property name
		guard let name:String = scanCharacters(from: propertyNameCharacterSet) else {
			scanLocation = originalLocation
			return nil
		}
		_ = scanCharacters(from: .whitespacesAndNewlines)
		guard scanString(":") != nil else {
			scanLocation = originalLocation
			return nil
		}
		_ = scanCharacters(from: .whitespacesAndNewlines)
		guard let value:String = scanCharacters(from: valueCharacterSet) else {
			scanLocation = originalLocation
			return nil
		}
		_ = scanCharacters(from: .whitespacesAndNewlines)
		guard scanString(";") != nil else {
			scanLocation = originalLocation
			return nil
		}
		return Declaration(name: name, value: value.trimmingCharacters(in: .whitespacesAndNewlines))
	}
	
	
	public func scanDeclarationBlock()->DeclarationBlock? {
		let originalLocation = scanLocation
		//scan away white space
		_ = scanCharacters(from: .whitespacesAndNewlines)
		//declaration blocks must begin with {
		guard scanString("{") != nil else {
			scanLocation = originalLocation
			return nil
		}
		//scan declarations until we hit }
		var declarations:[Declaration] = []
		while let newDeclaration:Declaration = scanDeclaration() {
			declarations.append(newDeclaration)
		}
		_ = scanCharacters(from: .whitespacesAndNewlines)
		//declaration block must end with }
		guard scanString("}") != nil else {
			scanLocation = originalLocation
			return nil
		}
		return DeclarationBlock(declarations: declarations)
	}
	
	
	public func scanRuleSet()->RuleSet? {
		let originalLocation = scanLocation
		var groups:[SelectorGroup] = []
		while let selectorGroup = scanSelectorGroup() {
			groups.append(selectorGroup)
			//if there is a , do another
			if scanString(",") == nil {
				break
			}
			_ = scanCharacters(from: .whitespacesAndNewlines)
		}
		guard let block = scanDeclarationBlock() else {
			scanLocation = originalLocation
			return nil
		}
		return RuleSet(selectorGroups: groups, block: block)
	}
	
}
