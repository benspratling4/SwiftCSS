//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation


extension Scanner {
	
	public func scanDimension()->(Float64, String)? {
		let originalLocation = scanLocation
		guard let number = scanDouble() else {
			return nil
		}
		guard let units = scanCharacters(from: .lowercaseLetters) else {
			scanLocation = originalLocation
			return nil
		}
		//TODO: try to recognzie the units
		return (number, units)
	}
	
}


//below here, WIP in dev, and not public

enum RelativeLengthUnits : String {
	case em, ex, cap, ch, ic, rem, lh, vw, vh, vi, vb, vmin, vmax
}

enum AbsoluteLengthUnits : String {
	case cm, mm, Q, `in`, pc, pt, px
}

enum AngleUnits : String {
	///There are 360 degrees in a full circle
	case deg
	
	///There are 400 gradians in a full circle
	case grad
	
	///There are 2π radians in a full circle
	case rad
	
	///There is 1 turn in a full circle.
	case turn
}


enum TimeUnits : String {
	case s, ms
}


enum FrequencyUnuits : String {
	case Hz, kHz
}


enum ResolutionUnits : String {
	case dpi, dpcm, dppx, x
}


enum PercentageUnits : String {
	case percent = "%"
}
