//
//  MockChatViewModel.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 10/10/2024.
//

import Foundation
import RxSwift
@testable import MuzzChat

class MockChatSocketService: ChatSocketServiceType {
    required init(userId: UUID) { }
    func deliverMessage(messageId: UUID) { }
    func markMessageAsRead(messageId: UUID) { }
}

class MockChatViewModel: ChatViewModelType {
    let socketService: ChatSocketServiceType
    let messagesUpdate = PublishSubject<MuzzChat.ChatMessagesUpdate>()
    let initialMessageUpdate = BehaviorSubject<ChatCellViewModel?>(value: nil)
    let didSendMessage = BehaviorSubject<Bool>(value: false)
    var otherUserName: String = "John Doe"
    
    let mockMatchMessage = ChatCellViewModel.system(
        .init(id: UUID(), dateString: "date1", timeString: "time1")
    )
    
    let mockMessages = [
        ChatCellViewModel.user(
            .init(id: UUID(),
                  message: "incoming",
                  isIncoming: true,
                  groupingRule: .sameGroup,
                  isRead: true,
                  isDelivered: false)
        ),
        ChatCellViewModel.user(
            .init(id: UUID(),
                  message: "outgoing",
                  isIncoming: false,
                  groupingRule: .sameGroup,
                  isRead: true,
                  isDelivered: false)
        )
    ]
    
    required init(otherUserId: UUID, socketService: ChatSocketServiceType) {
        self.socketService = socketService
    }
    
    func beginUpdates() {
        initialMessageUpdate.onNext(mockMatchMessage)
        messagesUpdate.onNext((mockMessages, false))
    }
    
    func sendNewMessage(_ message: String) {
        didSendMessage.onNext(true)
    }
    func viewDidEndDisplayingCell(with cellViewModel: ChatMessageCellViewModel) { }
}

