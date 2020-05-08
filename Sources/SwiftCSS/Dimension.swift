//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/8/20.
//

import Foundation


public struct Dimension {
	public var number:Float64
	public var unit:DimensionUnit
	
	public init(number:Float64, unit:DimensionUnit) {
		self.number = number
		self.unit = unit
	}
	
	public init?(value:String) {
		let scanner = Scanner(string: value)
		guard let (number, unit) = scanner.scanDimesions() else {
			return nil
		}
		self.number = number
		self.unit = unit
	}
	
}

public protocol DimensionUnit {
	
	init?(rawValue:String)
	
}


public enum RelativeLengthUnits : String, DimensionUnit, Equatable {
	case em, ex, cap, ch, ic, rem, lh, vw, vh, vi, vb, vmin, vmax
}


public enum AbsoluteLengthUnits : String, DimensionUnit, Equatable {
	case cm, mm, Q, `in`, pc, pt, px
}


public enum AngleUnits : String, DimensionUnit, Equatable {
	///There are 360 degrees in a full circle
	case deg
	
	///There are 400 gradians in a full circle
	case grad
	
	///There are 2π radians in a full circle
	case rad
	
	///There is 1 turn in a full circle.
	case turn
}


public enum TimeUnits : String, DimensionUnit, Equatable {
	case s, ms
}


public enum FrequencyUnits : String, DimensionUnit, Equatable {
	case Hz, kHz
}


public enum ResolutionUnits : String, DimensionUnit, Equatable {
	case dpi, dpcm, dppx, x
}


public enum PercentageUnits : String, DimensionUnit, Equatable {
	case percent = "%"
}
