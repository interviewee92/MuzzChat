//
//  ChatViewModelType.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 10/10/2024.
//

import Foundation
import RxSwift

typealias ChatMessagesUpdate = (messages: [ChatCellViewModel], shouldAnimate: Bool)

protocol ChatViewModelType {
    var messagesUpdate: PublishSubject<ChatMessagesUpdate> { get }
    var initialMessageUpdate: BehaviorSubject<ChatCellViewModel?> { get }
    var didSendMessage: BehaviorSubject<Bool> { get }
    var otherUserName: String { get }
    var socketService: ChatSocketServiceType { get }
        
    init?(otherUserId: UUID, socketService: ChatSocketServiceType)
    func beginUpdates()
    func sendNewMessage(_ message: String)
    func viewDidEndDisplayingCell(with cellViewModel: ChatMessageCellViewModel)
}
