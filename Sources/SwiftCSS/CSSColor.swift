//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation


public enum CSSColor : Equatable {
	
	case hex(String)
	case rgb(UInt8, UInt8, UInt8)
	case rgba(UInt8, UInt8, UInt8, Float)
	case hsl(UInt16, UInt8, UInt8)
	case hsla(UInt16, UInt8, UInt8, Float)
	case named(NamedColor)
	
	case currentColor
	
	///if possible, returns an array of 8-bit color values
	public func resolvedRGBA()->[UInt8]? {
		switch self {
			case .hex(let hexString):
				return hexString.cssColorFromHexString?.resolvedRGBA()
			
			case .rgb(let r, let g, let b):
				return [r, g, b, 255]
			
			case .rgba(let r, let g, let b, let a):
				let alpha = UInt8((min(max(a, 0.0), 1.0) * 255.0).rounded())
				return [r, g, b, alpha]
			
			case .hsl(let h, let s, let l):
				return CSSColor.hsla(h, s, l, 1.0).resolvedRGBA()
			
			case .hsla(let h, let s, let l, let a):
				let alpha = UInt8((min(max(a, 0.0), 1.0) * 255.0).rounded())
				let (r, g, b) = hslToRGB(h: max(0, min(360, Float(h)))
					,s: min(max(Float(s)/Float(100), 0), 1.0)
					,l: min(max(Float(l)/Float(100), 0), 1.0) )
				return [UInt8((255 * r).rounded())
						,UInt8((255 * g).rounded())
						,UInt8((255 * b).rounded())
						,alpha]
			
			case .named(let namedColor):
				return namedColor.resolvedColor.resolvedRGBA()
			
			case .currentColor:
				return nil
		}
	}
	
}


//https://en.wikipedia.org/wiki/HSL_and_HSV
///h 0...360, s 0...1, l 0...1
///r, g, b 0...1
fileprivate func hslToRGB(h:Float, s:Float, l:Float)->(r:Float, g:Float, b:Float) {
	//https://en.wikipedia.org/wiki/HSL_and_HSV
	let c:Float = (1.0 - abs(2.0 * l - 1.0)) * s
	let hPrime:Float = h/60.0
	let x = c * (1.0 - abs(hPrime.truncatingRemainder(dividingBy: 2.0) - 1.0))
	let r1:Float, g1:Float, b1:Float
	switch ceil(hPrime) {
	case 0.0, 1.0:
			(r1, g1, b1) = (c, x, 0)
		case 2.0:
			(r1, g1, b1) = (x, c, 0)
		case 3.0:
			(r1, g1, b1) = (0, c, x)
		case 4.0:
			(r1, g1, b1) = (0, x, c)
		case 5.0:
			(r1, g1, b1) = (x, 0, c)
		case 6.0:
			(r1, g1, b1) = (c, 0, x)
		default:
			(r1, g1, b1) = (0.0, 0.0, 0.0)
	}
	//add lightness
	let m:Float = l - c/2.0
	return (r:r1+m, g:g1+m, b:b1+m)
}


extension String {
	public var cssColorFromHexString:CSSColor? {
		//TODO: support 3-character codes
		let digits:[UInt8] = self.compactMap({ $0.fromHexDigit })
		if digits.count != 6 {
			return nil
		}
		let red:UInt8 = (digits[0] << 4) + digits[1]
		let green:UInt8 = (digits[2] << 4) + digits[3]
		let blue:UInt8 = (digits[4] << 4) + digits[5]
		
		return .rgb(red, green, blue)
	}
}


extension Character {
	
	fileprivate var fromHexDigit:UInt8? {
		switch self.lowercased() {
		case "0":
		return 0
			
		case "1":
		return 1
			
		case "2":
		return 2
		
		case "3":
		return 3
		
		case "4":
		return 4
		
		case "5":
		return 5
		
		case "6":
		return 6
		
		case "7":
		return 7
		
		case "8":
		return 8
		
		case "9":
		return 9
		
		case "a":
		return 10
		
		case "b":
		return 11
		
		case "c":
		return 12
		
		case "d":
		return 13
		
		case "e":
		return 14
		
		case "f":
		return 15
			
		default:
			return nil
		}
	}
	
}

//https://www.w3schools.com/cssref/css_colors.asp
public enum NamedColor : String, Equatable {
	
	case black, navy, darkblue, mediumblue, blue, darkgreen, green, teal, darkcyan, deepskyblue, darkturquoise
	case mediumspringgreen, lime, springgreen, aqua, cyan, midnightblue, dodgerblue, lightseagreen, forestgreen, seagreen
	case darkslategray, darkslategrey, limegreen, mediumseagreen, turquoise, royalblue, steelblue, darkslateblue
	case mediumturquoise, indigo, darkolivegreen, cadetblue, cornflowerblue, rebeccapurple, mediumaquamarine, dimgray
	case dimgrey, slateblue, olivedrab, slategray, slategrey, lightslategray, lightslategrey, mediumslateblue, lawngreen, chartreuse, aquamarine
	case maroon, purple, olive, gray, grey, skyblue, lightskyblue, blueviolet, darkred, darkmagenta, saddlebrown
	case darkseagreen, lightgreen, mediumpurple, darkviolet, palegreen, darkorchid, yellowgreen, sienna, brown
	case darkgray, darkgrey, lightblue, greenyellow, paleturquoise, lightsteelblue, powderblue, firebrick
	case darkgoldenrod, mediumorchid, rosybrown, darkkhaki, silver, mediumvioletred, indianred, peru, chocolate
	case tan, lightgray, lightgrey, thistle, orchid, goldenrod, palevioletred, crimson, gainsboro, plum, burlywood
	case lightcyan, lavender, darksalmon, violet, palegoldenrod, lightcoral, khaki, aliceblue, honeydew, azure
	case sandybrown, wheat, beige, whitesmoke, mintcream, ghostwhite, salmon, antiquewhite, linen
	case lightgoldenrodyellow, oldlace, red, fuchsia, magenta, deeppink, orangered, tomato, hotpink, coral
	case darkorange, lightsalmon, orange, lightpink, pink, gold, peachpuff, navajowhite, moccasin, bisque
	case mistyrose, blanchedalmond, papayawhip, lavenderblush, seashell, cornsilk, lemonchiffon, floralwhite
	case snow, yellow, lightyellow, ivory, white
	
	public init?(name:String) {
		self.init(rawValue:name.lowercased())
	}
	
	///
	public var resolvedColor:CSSColor {
		switch  self {
		case .black:
			return .hex("000000")
		case .navy:
			return .hex("000080")
		case .darkblue:
			return .hex("00008B")
		case .mediumblue:
			return .hex("0000CD")
		case .blue:
			return .hex("0000FF")
		case .darkgreen:
			return .hex("006400")
		case .green:
			return .hex("008000")
		case .teal:
			return .hex("008080")
		case .darkcyan:
			return .hex("008B8B")
		case .deepskyblue:
			return .hex("00BFFF")
		case .darkturquoise:
			return .hex("00CED1")
		case .mediumspringgreen:
			return .hex("00FA9A")
		case .lime:
			return .hex("00FF00")
		case .springgreen:
			return .hex("00FF7F")
		case .aqua:
			return .hex("00FFFF")
		case .cyan:
			return .hex("00FFFF")
		case .midnightblue:
			return .hex("191970")
		case .dodgerblue:
			return .hex("1E90FF")
		case .lightseagreen:
			return .hex("20B2AA")
		case .forestgreen:
			return .hex("228B22")
		case .seagreen:
			return .hex("2E8B57")
		case .darkslategray, .darkslategrey:
			return .hex("2F4F4F")
		case .limegreen:
			return .hex("32CD32")
		case .mediumseagreen:
			return .hex("3CB371")
		case .turquoise:
			return .hex("40E0D0")
		case .royalblue:
			return .hex("4169E1")
		case .steelblue:
			return .hex("4682B4")
		case .darkslateblue:
			return .hex("483D8B")
		case .mediumturquoise:
			return .hex("48D1CC")
		case .indigo:
			return .hex("4B0082")
		case .darkolivegreen:
			return .hex("556B2F")
		case .cadetblue:
			return .hex("5F9EA0")
		case .cornflowerblue:
			return .hex("6495ED")
		case .rebeccapurple:
			return .hex("663399")
		case .mediumaquamarine:
			return .hex("66CDAA")
		case .dimgray, .dimgrey:
			return .hex("696969")
		case .slateblue:
			return .hex("6A5ACD")
		case .olivedrab:
			return .hex("6B8E23")
		case .slategray, .slategrey:
			return .hex("708090")
		case .lightslategray, .lightslategrey:
			return .hex("778899")
		case .mediumslateblue:
			return .hex("7B68EE")
		case .lawngreen:
			return .hex("7CFC00")
		case .chartreuse:
			return .hex("7FFF00")
		case .aquamarine:
			return .hex("7FFFD4")
		case .maroon:
			return .hex("800000")
		case .purple:
			return .hex("800080")
		case .olive:
			return .hex("808000")
		case .gray, .grey:
			return .hex("808080")
		case .skyblue:
			return .hex("87CEEB")
		case .lightskyblue:
			return .hex("87CEFA")
		case .blueviolet:
			return .hex("8A2BE2")
		case .darkred:
			return .hex("8B0000")
		case .darkmagenta:
			return .hex("8B008B")
		case .saddlebrown:
			return .hex("8B4513")
		case .darkseagreen:
			return .hex("8FBC8F")
		case .lightgreen:
			return .hex("90EE90")
		case .mediumpurple:
			return .hex("9370DB")
		case .darkviolet:
			return .hex("9400D3")
		case .palegreen:
			return .hex("98FB98")
		case .darkorchid:
			return .hex("9932CC")
		case .yellowgreen:
			return .hex("9ACD32")
		case .sienna:
			return .hex("A0522D")
		case .brown:
			return .hex("A52A2A")
		case .darkgray, .darkgrey:
			return .hex("A9A9A9")
		case .lightblue:
			return .hex("ADD8E6")
		case .greenyellow:
			return .hex("ADFF2F")
		case .paleturquoise:
			return .hex("AFEEEE")
		case .lightsteelblue:
			return .hex("B0C4DE")
		case .powderblue:
			return .hex("B0E0E6")
		case .firebrick:
			return .hex("B22222")
		case .darkgoldenrod:
			return .hex("B8860B")
		case .mediumorchid:
			return .hex("BA55D3")
		case .rosybrown:
			return .hex("BC8F8F")
		case .darkkhaki:
			return .hex("BDB76B")
		case .silver:
			return .hex("C0C0C0")
		case .mediumvioletred:
			return .hex("C71585")
		case .indianred:
			return .hex("CD5C5C")
		case .peru:
			return .hex("CD853F")
		case .chocolate:
			return .hex("D2691E")
		case .tan:
			return .hex("D2B48C")
		case .lightgray, .lightgrey:
			return .hex("D3D3D3")
		case .thistle:
			return .hex("D8BFD8")
		case .orchid:
			return .hex("DA70D6")
		case .goldenrod:
			return .hex("DAA520")
		case .palevioletred:
			return .hex("DB7093")
		case .crimson:
			return .hex("DC143C")
		case .gainsboro:
			return .hex("DCDCDC")
		case .plum:
			return .hex("DDA0DD")
		case .burlywood:
			return .hex("DEB887")
		case .lightcyan:
			return .hex("E0FFFF")
		case .lavender:
			return .hex("E6E6FA")
		case .darksalmon:
			return .hex("E9967A")
		case .violet:
			return .hex("EE82EE")
		case .palegoldenrod:
			return .hex("EEE8AA")
		case .lightcoral:
			return .hex("F08080")
		case .khaki:
			return .hex("F0E68C")
		case .aliceblue:
			return .hex("F0F8FF")
		case .honeydew:
			return .hex("F0FFF0")
		case .azure:
			return .hex("F0FFFF")
		case .sandybrown:
			return .hex("F4A460")
		case .wheat:
			return .hex("F5DEB3")
		case .beige:
			return .hex("F5F5DC")
		case .whitesmoke:
			return .hex("F5F5F5")
		case .mintcream:
			return .hex("F5FFFA")
		case .ghostwhite:
			return .hex("F8F8FF")
		case .salmon:
			return .hex("FA8072")
		case .antiquewhite:
			return .hex("FAEBD7")
		case .linen:
			return .hex("FAF0E6")
		case .lightgoldenrodyellow:
			return .hex("FAFAD2")
		case .oldlace:
			return .hex("FDF5E6")
		case .red:
			return .hex("FF0000")
		case .fuchsia:
			return .hex("FF00FF")
		case .magenta:
			return .hex("FF00FF")
		case .deeppink:
			return .hex("FF1493")
		case .orangered:
			return .hex("FF4500")
		case .tomato:
			return .hex("FF6347")
		case .hotpink:
			return .hex("FF69B4")
		case .coral:
			return .hex("FF7F50")
		case .darkorange:
			return .hex("FF8C00")
		case .lightsalmon:
			return .hex("FFA07A")
		case .orange:
			return .hex("FFA500")
		case .lightpink:
			return .hex("FFB6C1")
		case .pink:
			return .hex("FFC0CB")
		case .gold:
			return .hex("FFD700")
		case .peachpuff:
			return .hex("FFDAB9")
		case .navajowhite:
			return .hex("FFDEAD")
		case .moccasin:
			return .hex("FFE4B5")
		case .bisque:
			return .hex("FFE4C4")
		case .mistyrose:
			return .hex("FFE4E1")
		case .blanchedalmond:
			return .hex("FFEBCD")
		case .papayawhip:
			return .hex("FFEFD5")
		case .lavenderblush:
			return .hex("FFF0F5")
		case .seashell:
			return .hex("FFF5EE")
		case .cornsilk:
			return .hex("FFF8DC")
		case .lemonchiffon:
			return .hex("FFFACD")
		case .floralwhite:
			return .hex("FFFAF0")
		case .snow:
			return .hex("FFFAFA")
		case .yellow:
			return .hex("FFFF00")
		case .lightyellow:
			return .hex("FFFFE0")
		case .ivory:
			return .hex("FFFFF0")
		case .white:
			return .hex("FFFFFF")
		}
	}
}
