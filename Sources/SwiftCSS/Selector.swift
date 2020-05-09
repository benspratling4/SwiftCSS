//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation

public struct CSSSelector {
	public var main:CSSSelectorMain
	public var attributes:[CSSSelectorAttribute]
//	public var pseudo:CSSSelectorPsuedo?
	
	public var cssString:String {
		var mainString = main.cssString + attributes.map({ $0.cssString }).joined()
		return mainString
	}
	
	
	public init(main:CSSSelectorMain, attributes:[CSSSelectorAttribute] = []) {
		self.main = main
		self.attributes = attributes
	}
	
	
	public var specificity:Int {
		//https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Cascade_and_inheritance#Specificity_2
		//thousands ignored, because inline styles override cascade styles in another algorithm
		var hundreds:Int = 0
		var tens:Int = 0
		var ones:Int = 0
		
		switch main {
		case .id(_):
			hundreds += 1
		case .className(_):
			tens += 1
		case .elementName(_):
			ones += 1
		default:
			break
		}
		tens += attributes.count
		
		return  100*hundreds + 10*tens + ones
	}
}



//TODO: write me
public enum CSSSelectorMain {
	case universal
	
	/// tag
	case elementName(String)
	
	/// .classname
	case className(String)
	
	///  # idname
	case id(String)
	
	public var cssString:String {
		switch self {
		case .universal:
			return "*"
		case .elementName(let name):
			return name
		case .className(let name):
			return "." + name
		case .id(let name):
			return "#" + name
		}
	}
	
}
	
//public enum CSSSelectorPsuedo {
//	//TODO: write me
//}


///[attr=value]
public struct CSSSelectorAttribute {
	//TODO: optional case insensitivity
	public var name:String
	
	///( operator, value (no "), caseInsensitive)
	public var operatorAndValue:(AttributeOperator, String, Bool)?
	
	public init(name:String, operatorAndValue:(AttributeOperator, String, Bool)?) {
		self.name = name
		self.operatorAndValue = operatorAndValue
	}
	
	public var cssString:String {
		if let (attrOperator, value, caseInsensitive) = operatorAndValue {
			let caseString:String = caseInsensitive ? " i" : ""
			return "[" + name + attrOperator.rawValue + value + "\"" + caseString + "]"
		} else {
			return "[" + name + "]"
		}
	}
	
	public enum AttributeOperator : String {
		case equals = "="
		
		///the attributes is a space-separated list, and one of the items is the one mentioned
		case listContains = "~="
		
		case prefix = "^="
		
		case suffix = "$="
		
		case contains = "*="
		
		///the vslue begins with the textvalue plus a hyphen
		case hyphenatedPrefix = "|="
		
	}
	
	///the attributes you pass in should contain any default values, probably
	public func matchesResolvedAttributes(_ attributes:[String:String])->Bool {
		guard let value:String = attributes[name] else {
			return false
		}
		guard let (op, comparedValue, caseInsensitive):(AttributeOperator, String, Bool) = operatorAndValue else {
			return true
		}
		let valueToCompare:String = caseInsensitive ? value.lowercased() : value
		let comparedValueToCompare:String = caseInsensitive ? comparedValue.lowercased() : comparedValue
		switch op {
		case .equals:
			return valueToCompare == comparedValueToCompare
		case .contains:
			return valueToCompare.contains(comparedValueToCompare)
		case .prefix:
			return valueToCompare.hasPrefix(comparedValueToCompare)
		case .suffix:
			return valueToCompare.hasSuffix(comparedValueToCompare)
		case .listContains:
			return valueToCompare.components(separatedBy: " ").contains(comparedValueToCompare)
		case .hyphenatedPrefix:
			return valueToCompare.hasPrefix(comparedValueToCompare + "-")
		}
	}
	
}


public enum SelectorCombinator {
	/// ,
//	case also	//this is wrong
	
	///" "
	case descendant
	
	///>
	case child
	
	///+
	case adjacentSibling
	
	/// ~
	case generalSibling
	
	///nothing, like element.class.class
	case moreSpecific
	
	public var cssString:String {
		switch self {
		case .descendant:
			return " "
		case .child:
			return ">"
		case .adjacentSibling:
			return " + "
		case .generalSibling:
			return " ~ "
		case .moreSpecific:
			return ""
		}
	}
	
}


public struct SelectorGroup {
	public var firstSelector:CSSSelector
	public var additionalSelectors:[(SelectorCombinator, CSSSelector)]
	
	public init(firstSelector:CSSSelector, additionalSelectors:[(SelectorCombinator, CSSSelector)] = []) {
		self.firstSelector = firstSelector
		self.additionalSelectors = additionalSelectors
	}
	
	public var cssString:String {
		return firstSelector.cssString + additionalSelectors.map({ $0.0.cssString + $0.1.cssString }).reduce("", +)
	}
	
	
	public var specificity:Int {
		var allSelectors:[CSSSelector] = [firstSelector]
		for (_, selector) in additionalSelectors {
			allSelectors.append(selector)
		}
		return allSelectors.map({ $0.specificity }).reduce(0, +)
	}
	
	//split into two groups, before and after
	func split(at combinator:SelectorCombinator)->(SelectorGroup, SelectorGroup)? {
		var pre:SelectorGroup = SelectorGroup(firstSelector: firstSelector)
		var startsPost:SelectorGroup?
		for (aCombinator, selector) in additionalSelectors {
			if startsPost != nil {
				startsPost?.additionalSelectors.append((aCombinator, selector))
				continue
			}
			if aCombinator == combinator {
				startsPost = SelectorGroup(firstSelector: selector)
				continue
			}
			pre.additionalSelectors.append((aCombinator, selector))
		}
		guard var post = startsPost else {
			return nil
		}
		return (pre, post)
	}
	
	
}
