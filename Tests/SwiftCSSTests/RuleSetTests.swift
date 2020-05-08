//
//  RuleSetTests.swift
//  
//
//  Created by Ben Spratling on 5/8/20.
//

import Foundation
import XCTest
@testable import SwiftCSS

final class RuleSetTests: XCTestCase {
	
    func testScanRuleSet() {
		
		let css:String = """
p {
	background-color:#6D9A0B;
}
"""
		let ruleSet:[RuleSet] = [RuleSet](css: css)
		XCTAssertEqual(ruleSet.count, 1)
		
	}
	
	
	func testMultipleSelectors() {
			let css:String = """
	p, h1 {
		background-color:#6D9A0B;
	}
	"""
			let ruleSet:[RuleSet] = [RuleSet](css: css)
			XCTAssertEqual(ruleSet.count, 1)
	}
	
	
	
    static var allTests = [
        ("testScanRuleSet", testScanRuleSet),
    ]
}
