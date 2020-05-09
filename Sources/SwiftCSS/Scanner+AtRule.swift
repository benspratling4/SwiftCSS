//
//  Scanner+AtRule.swift
//  
//
//  Created by Ben Spratling on 5/9/20.
//

import Foundation


extension Scanner {
	
	///if the scanner detects an at rule, it ignores it and leaves the scanLocation at a place following the at rule
	///otherwise the scanLocation is left whereever it was
	func scanAtRule()->Bool {
		let originalLocation = scanLocation
		//ignore leading whitespace
		_ = scanCharacters(from: .whitespacesAndNewlines)
		if scanString("@") == nil {
			scanLocation = originalLocation
			return false
		}
		//scan the keyword
		guard let keyword = scanCharacters(from:cssAtRuleKeywordCharcters) else {
			scanLocation = originalLocation
			return false
		}
		_ = scanCharacters(from: .whitespacesAndNewlines)
		//scan until the next ; or CSS block, "whichever comes first"
		guard scanUpToCharacters(from: determinesHowAtRulesEndSet) != nil else {
			scanLocation = originalLocation
			return false
		}
		guard let determinant = scanCharacters(from: determinesHowAtRulesEndSet) else {
			scanLocation = originalLocation
			return false
		}
		//if it's a semicolon, we're done
		if determinant == ";" {
			return true
		}
		//otherwise, it's a block
		scanUntilEndOfPotentiallyNestedCurlyBlock()
		return true
	}
	
	func scanUntilEndOfPotentiallyNestedCurlyBlock() {
		let originalLocation = scanLocation
		guard scanUpToCharacters(from: curlyBlockNestingEnding) != nil else {
			scanLocation = originalLocation
			return
		}
		//we're done
		if scanString("}") != nil {
			return
		}
		if scanString("{") == nil {
			//fail
			return
		}
		//else it's a {
		//finish the new block
		scanUntilEndOfPotentiallyNestedCurlyBlock()
		//now try to finish this block again
		scanUntilEndOfPotentiallyNestedCurlyBlock()
	}
	
	
	
	public func remainingString()->String? {
		if isAtEnd {
			return nil
		}
		return String(self.string.suffix(from: self.string.index(self.string.startIndex, offsetBy: scanLocation)))
	}
	
}

fileprivate let cssAtRuleKeywordCharcters:CharacterSet = CharacterSet.letters.union(.init(charactersIn: "-"))
fileprivate let determinesHowAtRulesEndSet:CharacterSet = CharacterSet(charactersIn: ";{")
fileprivate let curlyBlockNestingEnding:CharacterSet = CharacterSet(charactersIn: "{}")


