//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation


public struct Declaration {
	public var name:String
	public var value:String
	
	public init(name:String, value:String) {
		self.name = name
		self.value = value
	}
	
	
	public var cssString:String {
		return name + " : " + value + ";"
	}
}


public struct DeclarationBlock {
	public var declarations:[Declaration]
	
	public init(declarations:[Declaration]) {
		self.declarations = declarations
	}
	
	public var cssString:String  {
		return " {\n" + declarations.map({"\t" + $0.cssString}).joined(separator: "\n") + "\n}"
	}
	
}


public struct RuleSet {
	public var selectorGroups:[SelectorGroup]
	public var block:DeclarationBlock
	
	public init(selectorGroups:[SelectorGroup], block:DeclarationBlock) {
		self.selectorGroups = selectorGroups
		self.block = block
	}
	
}


extension Array where Element == RuleSet {
	
	public init(css:String) {
		let scanner = Scanner(string: css)
		var ruleSets:[RuleSet] = []
		while let set = scanner.scanRuleSet() {
			ruleSets.append(set)
		}
		self = ruleSets
	}
	
}

