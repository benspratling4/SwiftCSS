//
//  Scanner+CSSColor.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation

let hexCharacterSet:CharacterSet = CharacterSet(charactersIn: "0123456789abcdefABCDEF")

extension Scanner {
	
	///backs up if it fails
	///get passed any whitespace if it fails
	public func scanCssColor()->CSSColor? {
		let originalLocation:Int = scanLocation
		if scanString("#") != nil {
			guard let hexChars:String = scanCharacters(from: hexCharacterSet)
				,hexChars.count == 6
				else {
					scanLocation = originalLocation
				return nil
			}
			return .hex(hexChars)
		}
		if scanString("rgba(") != nil {
			//red
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let rInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let red:UInt8 = UInt8(clamping: rInt)
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			//green
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let gInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let green:UInt8 = UInt8(clamping: gInt)
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			
			//blue
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let bInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let blue:UInt8 = UInt8(clamping: bInt)
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			//alpha
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let alpha:Float = scanFloat() else {
				scanLocation = originalLocation
				return nil
			}
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(")")
			
			return CSSColor.rgba(red, green, blue, alpha)
		}
		if scanString("rgb(") != nil {
			//red
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let rInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let red:UInt8 = UInt8(clamping: rInt)
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			//green
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let gInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let green:UInt8 = UInt8(clamping: gInt)
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			
			//blue
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let bInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let blue:UInt8 = UInt8(clamping: bInt)
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(")")
			
			return CSSColor.rgb(red, green, blue)
		}
		
		if scanString("hsla(") != nil {
			//hue
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let hInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let h:UInt16 = UInt16(clamping: hInt)
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			//saturation
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let sInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let s:UInt8 = UInt8(clamping: sInt)
			guard scanString("%") != nil else {
				scanLocation = originalLocation
				return nil
			}
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			
			//lightness
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let lInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let l:UInt8 = UInt8(clamping: lInt)
			guard scanString("%") != nil else {
				scanLocation = originalLocation
				return nil
			}
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			//alpha
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let alpha:Float = scanFloat() else {
				scanLocation = originalLocation
				return nil
			}
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(")")
			
			return CSSColor.hsla(h, s, l, alpha)
		}
		if scanString("hsl(") != nil {
			//hue
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let hInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let h:UInt16 = UInt16(clamping: hInt)
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			//saturation
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let sInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let s:UInt8 = UInt8(clamping: sInt)
			guard scanString("%") != nil else {
				scanLocation = originalLocation
				return nil
			}
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(",")
			
			
			//lightness
			_ = scanCharacters(from: .whitespacesAndNewlines)
			guard let lInt = scanInt() else {
				scanLocation = originalLocation
				return nil
			}
			let l:UInt8 = UInt8(clamping: lInt)
			guard scanString("%") != nil else {
				scanLocation = originalLocation
				return nil
			}
			_ = scanCharacters(from: .whitespacesAndNewlines)
			_ = scanString(")")
			
			return CSSColor.hsl(h, s, l)
		}
		if scanString("currentcolor") != nil {
			return CSSColor.currentColor
		}
		//try named colors
		guard let letters = scanCharacters(from: CharacterSet.letters)
			,let named = NamedColor(name: letters)
			else {
				scanLocation = originalLocation
			return nil
		}
		return .named(named)
	}
}
