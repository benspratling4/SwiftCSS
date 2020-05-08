//
//  ColorTests.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation
import XCTest
@testable import SwiftCSS

final class ColorTests: XCTestCase {
    func testHexColors() {
		guard let color = "A6935F".cssColorFromHexString else {
			XCTFail("failed to parse color")
			return
		}
		guard case .rgb(let r, let g, let b) = color else {
			XCTFail("failed to resolve as rgb")
			return
		}
		
		XCTAssertEqual(r, 0xA6)
		XCTAssertEqual(g, 0x93)
		XCTAssertEqual(b, 0x5F)
    }

	
	func testHSLConversion() {
		let testCases:[(UInt16, UInt8, UInt8, [UInt8])] = [
			(120, 100, 50, [0,255,0,255]),
			(0, 100, 50, [255,0,0,255]),
			(240, 100, 50, [0,0,255,255]),
		]
		
		for (h, s, l, answer) in testCases {
			guard let result = CSSColor.hsl(h, s, l).resolvedRGBA() else {
				XCTFail("unable to obtain rgb bytes")
				return
			}
			XCTAssertEqual(answer, result)
		}
	}
	
	
	func testScanColorNames() {
		let testCases:[(String, NamedColor?)] = [
			("blah", nil),
			("DimGray", .dimgray),
			("IndianRed", .indianred),
		]
		
		for (string, answer) in testCases {
			let scannar = Scanner(string: string)
			guard let color = scannar.scanCssColor() else {
				XCTAssertNil(answer)
				continue
			}
			guard case .named(let namedColor) = color else {
				XCTAssertNil(answer)
				continue
			}
			XCTAssertEqual(namedColor, answer)
		}
	}
	
	
	func testScanHexColors() {
		let testCases:[(String, String?)] = [
			("#562947", "562947"),
			("#257", nil),
			("#vbvjekl", nil),
			("#5a2b4c", "5a2b4c"),
			("#5A2B4C", "5A2B4C"),
		]
		
		for (string, answer) in testCases {
			let scannar = Scanner(string: string)
			guard let color = scannar.scanCssColor() else {
				XCTAssertNil(answer)
				continue
			}
			guard case .hex(let hexString) = color else {
				XCTAssertNil(answer)
				continue
			}
			XCTAssertEqual(hexString, answer)
		}
	}
	
	
	func testScanRGBColors() {
		let testCases:[(String, [UInt8]?)] = [
			("rgb( 255\n, 089\n, 234\t)", [255, 89, 234]),
			("rgb(-255\n, 089\n, 234\t)", [0, 89, 234]),
			("rgb(255\n, 3469\n, 234\t)", [255, 255, 234]),
		]
		
		for (string, answer) in testCases {
			let scannar = Scanner(string: string)
			guard let color = scannar.scanCssColor() else {
				XCTAssertNil(answer)
				continue
			}
			guard case .rgb(let r, let g, let b) = color else {
				XCTAssertNil(answer)
				continue
			}
			XCTAssertEqual([r, g, b], answer)
		}
	}
	
	
	func testScanHSLAColors() {
		let testCases:[(String, (UInt16, UInt8, UInt8, Float)?)] = [
			("hsla( 0\n, 089%\n, 100%\t, 0.2)", (0, 89, 100, 0.2)),
		]
		
		for (string, answer) in testCases {
			let scannar = Scanner(string: string)
			guard let color = scannar.scanCssColor() else {
				XCTAssertNil(answer)
				continue
			}
			guard case .hsla(let h, let s, let l, let a) = color else {
				XCTAssertNil(answer)
				continue
			}
			guard let ans = answer else {
				XCTFail("got non nil answer")
				continue
			}
			XCTAssertEqual(h, ans.0)
			XCTAssertEqual(s, ans.1)
			XCTAssertEqual(l, ans.2)
			XCTAssertEqual(a, ans.3, accuracy: 0.01)
		}
	}
	
	
	/*
	func testOneByteIntegerRegex() {
		let regex = try! NSRegularExpression(pattern: oneByteIntergerRegEx, options: [])
		let stringValue = NSString("100")
		let match = regex.firstMatch(in: stringValue as String, options: [.anchored], range: NSRange(location: 0, length: stringValue.length))
		XCTAssertNotNil(match)
	}
	*/
	
	
    static var allTests = [
        ("testHexColors", testHexColors),
		("testHSLConversion", testHSLConversion),
		("testScanColorNames", testScanColorNames),
		("testScanHexColors", testScanHexColors),
		("testScanRGBColors", testScanRGBColors),
		("testScanHSLAColors", testScanHSLAColors),
    ]
}






