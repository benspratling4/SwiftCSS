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
