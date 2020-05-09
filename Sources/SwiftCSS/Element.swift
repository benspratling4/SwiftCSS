//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation


///an element in the cascade
public class Element {
	public var name:String
	public var id:String?
	public var classes:[String]
	public var attributes:[String:String]
	
	///extracts id and classes from attributes
	public init(name:String, attributes:[String:String]) {
		self.name = name
		var attrsWithoutIdOrClass:[String:String] = attributes
		self.id = attrsWithoutIdOrClass.removeValue(forKey: "id")
		self.classes = attrsWithoutIdOrClass.removeValue(forKey: "class")?.components(separatedBy: " ") ?? []
		self.attributes = attrsWithoutIdOrClass
	}
}


extension CSSSelector {
	
	public func selectsElement(_ element:Element)->Bool {
		switch self.main {
		case .universal:
			break
		case .elementName(let elementName):
			if element.name != elementName {
				return false
			}
		case .className(let className):
			if !element.classes.contains(className) {
				return false
			}
		case .id(let id):
			if element.id != id {
				return false
			}
		}
		return attributes.map({ $0.matchesResolvedAttributes(element.attributes) }).reduce(true, { $0 && $1 })
	}
	
}


extension Array where Element == SwiftCSS.Element {
	
	public func evaluateCascade(rules:[RuleSet], inlineStyle:[Declaration])->[Declaration] {
		var matchingDeclarations:[String:[(SelectorGroup, Declaration)]] = [:]
		
		for rule in rules {
			guard let selectorGroup:SelectorGroup = rule.selectorGroups
				.filter(self.selectorGroupApplies)
				.sorted(by: {$0.specificity <= $1.specificity})
				.last
				else { continue }
			for declaration in rule.block.declarations {
				var applicableDeclaractions:[(SelectorGroup, Declaration)] = matchingDeclarations[declaration.name] ?? []
				applicableDeclaractions.append((selectorGroup, declaration))
				matchingDeclarations[declaration.name] = applicableDeclaractions
			}
		}
		
		var finalDeclarations:[String:Declaration] = [:]
		for (key, selectorGroupsAndDeclarations) in matchingDeclarations {
			guard let (selector, declaration) = selectorGroupsAndDeclarations.first else {
				continue
			}
			if selectorGroupsAndDeclarations.count == 1 {
				finalDeclarations[key] = declaration
				continue
			}
			let resolvedSelectorAndDeclaration = selectorGroupsAndDeclarations.reduce((selector, declaration), specificity)
			finalDeclarations[key] = resolvedSelectorAndDeclaration.1
		}
		
		//override with inline styles
		for decl in inlineStyle {
			finalDeclarations[decl.name] = decl
		}
		
		return [Declaration](finalDeclarations.values)
	}
	
	
	func selectorGroupApplies(_ group:SelectorGroup)->Bool {
		var stack = self
		guard stack.count > 0 else { return false }
		let child:SwiftCSS.Element = stack.removeLast()
		if let (parentGroup, childGroup) = group.split(at: .child) {
			guard [child].selectorGroupApplies(childGroup) else { return false }
			guard let parentElement = stack.last else { return false }
			return [parentElement].selectorGroupApplies(parentGroup)
		}
		if let (ancestorGroup, childGroup) = group.split(at: .descendant) {
			guard [child].selectorGroupApplies(childGroup) else { return false }
			//find any matching parent element
			for ancestor in stack.reversed() {
				//this isn't quite right, we want to pass the entire previous stack for each ancestor node
				if [ancestor].selectorGroupApplies(ancestorGroup) {
					return true
				}
			}
			return false
		}
		
		guard group.firstSelector.selectsElement(child) else { return false }
		//each additional selector
		for (op, selector) in group.additionalSelectors {
			switch op {
			case .moreSpecific:
				if !selector.selectsElement(child) {
					return false
				}
			default://ignoring sibling operators
				continue
			}
		}
		return true
	}
	
}


//return the winning specificity
internal func specificity(_ lhs:(SelectorGroup, Declaration), _ rhs:(SelectorGroup, Declaration))->(SelectorGroup, Declaration) {
	//https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Cascade_and_inheritance#Specificity_2
	if increasingSpecificityOrder(lhs.0, rhs.0) {
		return rhs
	} else {
		return lhs
	}
}

internal func increasingSpecificityOrder(_ lhs:SelectorGroup, _ rhs:SelectorGroup)->Bool {
	//TODO: write me
	if lhs.specificity > rhs.specificity {
		return false
	}
	return true
}
