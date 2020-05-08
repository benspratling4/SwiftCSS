//
//  DimensionTests.swift
//  
//
//  Created by Ben Spratling on 5/8/20.
//

import Foundation
import XCTest
@testable import SwiftCSS

final class DimensionTests: XCTestCase {
	
    func testLength() {
		let value = "13.5em"
		let scanner = Scanner(string: value)
		guard let (number, unit) = scanner.scanDimesion(allowedUnit:RelativeLengthUnits.self) else {
			XCTFail("")
			return
		}
		XCTAssertEqual(number, 13.5)
		XCTAssertEqual(unit, RelativeLengthUnits.em)
		
	}
	
    static var allTests = [
        ("testLength", testLength),
    ]
}

