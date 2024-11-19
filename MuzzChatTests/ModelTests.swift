//
//  ModelTests.swift
//  MuzzChatTests
//
//  Created by Barlomiej Wojdan on 03/10/2024.
//

import XCTest
@testable import MuzzChat

final class ModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    // MARK: - User
    
    func testUserModel_displayNameIfFormattedCorrectly() {
        let mock = User(
            id: UUID(),
            firstName: "John",
            lastName: "Doe")
        
        let expectedValue = "John Doe"
        
        XCTAssertEqual(mock.displayName, expectedValue)
    }
}
