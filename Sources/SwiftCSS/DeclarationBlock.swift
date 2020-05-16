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
	
	public var cssString:String  {
		selectorGroups.map({ $0.cssString }).joined(separator: ", ") + block.cssString
	}
}


extension Array where Element == RuleSet {
	
	public init(css:String) {
		let scanner = Scanner(string: css)
		scanner.charactersToBeSkipped = nil
		var ruleSets:[RuleSet] = []
		while let set = scanner.scanRuleSet() {
			ruleSets.append(set)
		}
		self = ruleSets
	}
	
}



extension Array where Element == Declaration {
	
	public init(inlineStyle:String) {
		let scanner = Scanner(string: inlineStyle)
		scanner.charactersToBeSkipped = nil
		var declarations:[Declaration] = []
		while let newDeclaration:Declaration = scanner.scanDeclaration() {
			declarations.append(newDeclaration)
		}
		_ = scanner.scanCharacters(from: .whitespacesAndNewlines)
		self = declarations
	}
}
