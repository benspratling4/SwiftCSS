//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation

public struct CSSSelector {
	public var main:CSSSelectorMain
	public var attributes:CSSSelectorAttribute?
//	public var pseudo:CSSSelectorPsuedo?
	
	public var cssString:String {
		var mainString = main.cssString
		if let attrString:String = attributes?.cssString {
			mainString += attrString
		}
		return mainString
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
	
	public var operatorAndValue:(AttributeOperator, String)?
	
	public var cssString:String {
		if let (attrOperator, value) = operatorAndValue {
			return "[" + name + attrOperator.rawValue + value + "\"]"
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
		guard let (op, comparedValue):(AttributeOperator, String) = operatorAndValue else {
			return true
		}
		switch op {
		case .equals:
			return value == comparedValue
		case .contains:
			return value.contains(comparedValue)
		case .prefix:
			return value.hasPrefix(comparedValue)
		case .suffix:
			return value.hasSuffix(comparedValue)
		case .listContains:
			return value.components(separatedBy: " ").contains(comparedValue)
		case .hyphenatedPrefix:
			return value.hasPrefix(comparedValue + "-")
		}
	}
	
}


public enum SelectorCombinator {
	/// ,
	case also
	
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
		case .also:
			return ", "
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
	
	
	//TODO: func matchesLastItemInStack([Element])->Bool
}
