//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation


extension Scanner {
	
	public func scanDimesion()->(Float64, String)? {
		let originalLocation = scanLocation
		guard let number = scanDouble() else {
			return nil
		}
		guard let units = scanCharacters(from:.cssUnitCharacters) else {
			scanLocation = originalLocation
			return nil
		}
		return (number, units)
	}
	
	public func scanDimesion<UnitType>(allowedUnit:UnitType.Type)->(Float64, UnitType)? where UnitType : DimensionUnit {
		let originalLocation = scanLocation
		guard let number = scanDouble() else {
			return nil
		}
		guard let units = scanCharacters(from:.cssUnitCharacters) else {
			scanLocation = originalLocation
			return nil
		}
		if let unit = allowedUnit.init(rawValue: units) {
			return (number, unit)
		}
		scanLocation = originalLocation
		return nil
	}
	
	public func scanDimesions()->(Float64, DimensionUnit)? {
		let originalLocation = scanLocation
		guard let number = scanDouble() else {
			return nil
		}
		guard let units = scanCharacters(from:.cssUnitCharacters) else {
			scanLocation = originalLocation
			return nil
		}
		if let unit = PercentageUnits(rawValue: units) {
			return (number, unit)
		}
		if let unit = RelativeLengthUnits(rawValue: units) {
			return (number, unit)
		}
		if let unit = AbsoluteLengthUnits(rawValue: units) {
			return (number, unit)
		}
		if let unit = AngleUnits(rawValue: units) {
			return (number, unit)
		}
		if let unit = TimeUnits(rawValue: units) {
			return (number, unit)
		}
		if let unit = FrequencyUnits(rawValue: units) {
			return (number, unit)
		}
		if let unit = ResolutionUnits(rawValue: units) {
			return (number, unit)
		}
		scanLocation = originalLocation
		return nil
	}
	
}

extension CharacterSet {
	public static let cssUnitCharacters:CharacterSet = CharacterSet.letters.union(CharacterSet(charactersIn: "%"))
}
