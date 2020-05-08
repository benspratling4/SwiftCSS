//
//  CascadeTests.swift
//  
//
//  Created by Ben Spratling on 5/8/20.
//

import Foundation
import XCTest
@testable import SwiftCSS

final class CascadeTests: XCTestCase {
	
    func testLaterIdenticalSelectorsWin() {
		let css:String = """
p {
	background-color:#000000;
}
p {
	background-color:#FFFFFF;
}
"""
		let ruleSets:[RuleSet] = [RuleSet](css: css)
		XCTAssertEqual(ruleSets.count, 2)
		let elementStack = [Element(name: "p", attributes: [:])]
		let decls = elementStack.evaluateCascade(rules: ruleSets, inlineStyle: [])
		XCTAssertEqual(decls.count, 1)
		XCTAssertEqual(decls[0].name, "background-color")
		XCTAssertEqual(decls[0].value, "#FFFFFF")
	}
	
	 func testMoreSpecificSelectorsWin() {
			let css:String = """
	p.black {
		background-color:#000000;
	}
	p {
		background-color:#FFFFFF;
	}
	"""
			let ruleSets:[RuleSet] = [RuleSet](css: css)
			XCTAssertEqual(ruleSets.count, 2)
			let elementStack = [Element(name: "p", attributes: ["class":"black"])]
			let decls = elementStack.evaluateCascade(rules: ruleSets, inlineStyle: [])
			XCTAssertEqual(decls.count, 1)
			XCTAssertEqual(decls[0].name, "background-color")
			XCTAssertEqual(decls[0].value, "#000000")
		}
	

    static var allTests = [
        ("testLaterIdenticalSelectorsWin", testLaterIdenticalSelectorsWin),
    ]
}
