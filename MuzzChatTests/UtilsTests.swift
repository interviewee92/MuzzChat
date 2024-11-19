//
//  UtilsTests.swift
//  MuzzChatTests
//
//  Created by Barlomiej Wojdan on 03/10/2024.
//

import XCTest
@testable import MuzzChat

final class UtilsTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    
    func testUIApplicationExtension_hasCorrectIsRTLValue() {
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            XCTAssertTrue(UIApplication.isRTL)
        } else {
            XCTAssertFalse(UIApplication.isRTL)
        }
    }
    
    func testTextAlignmentExtension_hasCorrectActualValue() {
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            XCTAssertTrue(NSTextAlignment.leading == .right)
            XCTAssertTrue(NSTextAlignment.trailing == .left)
        } else {
            XCTAssertTrue(NSTextAlignment.leading == .left)
            XCTAssertTrue(NSTextAlignment.trailing == .right)
        }
    }
    
    func testUIEdgeInsetsExtension_producesCorrectValue() {
        XCTAssertEqual(UIEdgeInsets(padding: 10), UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        XCTAssertEqual(UIEdgeInsets(horizontal: 10, vertical: 20), UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    }
    
    func testCharacterExtension_isEmojiWorksCorrectly() {
        XCTAssertFalse(Character(" ").isEmoji)
        XCTAssertFalse(Character("1").isEmoji)
        XCTAssertFalse(Character("-").isEmoji)
        XCTAssertFalse(Character("a").isEmoji)

        XCTAssertTrue(Character("☺️").isEmoji)
        XCTAssertTrue(Character("🎈").isEmoji)
        XCTAssertTrue(Character("🍔").isEmoji)
    }
    
    func testCollectionExtension_ifIndexOutOfBoundReturnsNilSafetly() {
        let array = [0]
        
        XCTAssertEqual(array[safe: 0], 0)
        XCTAssertEqual(array[safe: 1], nil)
    }
    
    func testCollectionExtension_isEmptyOrNilWorksCorrectly() {
        let notEmptyOptionalCollection: [Int]? = [0]
        XCTAssertFalse(notEmptyOptionalCollection.isEmptyOrNil)

        let emptyOptionalCollection: [Int]? = []
        XCTAssertTrue(emptyOptionalCollection.isEmptyOrNil)
        
        let nilCollection: [Int]? = nil
        XCTAssertTrue(nilCollection.isEmptyOrNil)
    }
    
    func testChatMessageGroupingRule_ifCalculatesRuleCorrectly() {
        
        let now = Date()
        let earlier10s = now.addingTimeInterval(-10)
        let earlier20s = now.addingTimeInterval(-20)
        let earlier10m = now.addingTimeInterval(-10 * 60)
        let earlier2h = now.addingTimeInterval(-60 * 60 * 2)
        
        // Same sender & less than 20s -> Same group
        XCTAssertEqual(
            ChatMessageGroupingRule.rule(forOlderMessageDate: earlier10s, newerMessageDate: now, isSameSender: true),
            ChatMessageGroupingRule.sameGroup
        )
        
        // Same sender & 20s or more -> Same group
        XCTAssertEqual(
            ChatMessageGroupingRule.rule(forOlderMessageDate: earlier20s, newerMessageDate: now, isSameSender: true),
            ChatMessageGroupingRule.differentGroup
        )
        
        XCTAssertEqual(
            ChatMessageGroupingRule.rule(forOlderMessageDate: earlier10m, newerMessageDate: now, isSameSender: true),
            ChatMessageGroupingRule.differentGroup
        )
        
        // Different senders & less than 20s -> Different group
        XCTAssertEqual(
            ChatMessageGroupingRule.rule(forOlderMessageDate: earlier10s, newerMessageDate: now, isSameSender: false),
            ChatMessageGroupingRule.differentGroup
        )
        
        // Different senders & less than 1h -> Different group
        XCTAssertEqual(
            ChatMessageGroupingRule.rule(forOlderMessageDate: earlier10m, newerMessageDate: now, isSameSender: false),
            ChatMessageGroupingRule.differentGroup
        )
        
        // Different senders & more than 1h -> Different group
        XCTAssertEqual(
            ChatMessageGroupingRule.rule(forOlderMessageDate: earlier2h, newerMessageDate: now, isSameSender: false),
            ChatMessageGroupingRule.differentSection
        )
        
        // Same sender & more than 1h -> Different group
        XCTAssertEqual(
            ChatMessageGroupingRule.rule(forOlderMessageDate: earlier2h, newerMessageDate: now, isSameSender: true),
            ChatMessageGroupingRule.differentSection
        )
        
        // No older message -> New section
        XCTAssertEqual(
            ChatMessageGroupingRule.rule(forOlderMessageDate: nil, newerMessageDate: now, isSameSender: false),
            ChatMessageGroupingRule.differentSection
        )
    }
}
