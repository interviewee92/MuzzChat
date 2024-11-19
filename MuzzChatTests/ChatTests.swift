//
//  ChatTests.swift
//  MuzzChatTests
//
//  Created by Barlomiej Wojdan on 03/10/2024.
//

import XCTest
@testable import MuzzChat

final class ChatTests: XCTestCase {
    
    var view: ChatView!
    var controller: ChatViewController!
    var mockSocketService: MockChatSocketService!
    var mockViewModel: MockChatViewModel!

    override func setUp() {
        super.setUp()
        view = ChatView(frame: .screenRect)

        mockSocketService = MockChatSocketService(userId: UUID())
        mockViewModel = MockChatViewModel(otherUserId: UUID(), socketService: mockSocketService)
        
        controller = ChatViewController(viewModel: mockViewModel)
        _ = controller.view
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - ChatView

    func testChatView_subviewsAreSetUp() throws {

        XCTAssertNotNil(view.tableView.superview)
        XCTAssertNotNil(view.sendButton.superview)
        XCTAssertNotNil(view.inputTextView.superview)
    }
    
    func testChatView_inputPlaceholderIsSet() throws {
        let view = ChatView(frame: .screenRect)
        let expectedValue = "Test"
        view.inputPlaceholder = expectedValue

        XCTAssertEqual(view.inputPlaceholder, expectedValue)
    }

    func testChatView_messageToSendIsPreparedCorrectly() throws {
        let expectedValue = "abc"
        
        view.inputTextView.text = "abc"
        XCTAssertEqual(view.prepareMessage(), expectedValue)
        
        view.inputTextView.text = " abc "
        XCTAssertEqual(view.prepareMessage(), expectedValue)
        
        view.inputTextView.text = "\n  abc  \n"
        XCTAssertEqual(view.prepareMessage(), expectedValue)
    }
    
    func testChatView_registeredCellClasses() throws {
        XCTAssertNotNil(view.tableView.dequeueReusableCell(withIdentifier: ChatSystemMessageCell.reuseIdentifier))
        XCTAssertNotNil(view.tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.reuseIdentifier))
    }
    
    func testChatView_sendButtonUserInteractionEnabledStates() throws {
        view.inputTextView.text = ""
        view.textViewDidChange(view.inputTextView)
        XCTAssertTrue(!view.sendButton.isUserInteractionEnabled)
        
        view.inputTextView.text = "abc"
        view.textViewDidChange(view.inputTextView)
        XCTAssertTrue(view.sendButton.isUserInteractionEnabled)
    }
    
    // MARK: - ChatViewController
    
    func testChatViewController_hasSetCorrectView() {
        XCTAssertTrue(controller.view is ChatView)
    }
    
    func testChatViewController_dataSourceIsSetup() {
        XCTAssertTrue(controller.dataSource != nil)
        
        ChatSection.allCases.forEach {
            XCTAssertNotNil(controller.dataSource.index(for: $0))
        }
    }
    
    func testChatViewController_isBoundWillViewModelAndReceivingUpdates() {
        let indexPath = controller.dataSource.indexPath(for: mockViewModel.mockMatchMessage)
        XCTAssertNotNil(indexPath)
        XCTAssertTrue(controller.dataSource.sectionIdentifier(for: indexPath!.section) == .system)
        
        mockViewModel.mockMessages.forEach {
            let indexPath = controller.dataSource.indexPath(for: $0)
            XCTAssertNotNil(indexPath)
            XCTAssertTrue(controller.dataSource.sectionIdentifier(for: indexPath!.section) == .messages)
        }
    }
  
    func testChatViewController_isBoundWithViewAndCorrectActions() {
        guard let view = (controller.view as? ChatView) else {
            XCTAssertTrue(false)
            return
        }

        view.inputTextView.text = "Message to send"
        XCTAssertFalse(view.inputTextView.text.isEmptyOrNil)
        
        // Controller passes the message to viewModel,
        // which triggers didSendMessage relay
        // which clears input in view
        // hence binding is correct.
        
        view.sendButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(view.inputTextView.text.isEmptyOrNil)
    }
}
