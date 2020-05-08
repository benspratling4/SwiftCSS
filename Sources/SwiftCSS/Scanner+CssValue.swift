//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation

extension Scanner {
	
	///scan any css value type
	//TODO: support other value types
	public func scanCssValue()->CSSValue? {
		if scanString("unset") != nil {
			return .unset
		}
		if scanString("revert") != nil {
			return .revert
		}
		if let color = scanCssColor() {
			return .color(color)
		}
		return nil
	}
}
