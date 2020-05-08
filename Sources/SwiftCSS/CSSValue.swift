//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation

public enum CSSValue {
	case color(CSSColor)
	//TODO: add other types of values
	case unset, revert, initial, inherit
	
	public var cssString:String {
		switch self {
		case .color(let color):
			return color.cssString
		case .unset:
			return "unset"
		case .revert:
			return "revert"
		case .initial:
			return "initial"
		case .inherit:
			return "inherit"
		}
	}
}
