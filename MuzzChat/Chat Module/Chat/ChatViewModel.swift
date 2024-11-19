//
//  ChatViewModel.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import Foundation
import RealmSwift
import RxSwift

final class ChatViewModel: ChatViewModelType {
    
    let messagesUpdate = PublishSubject<ChatMessagesUpdate>()
    let initialMessageUpdate = BehaviorSubject<ChatCellViewModel?>(value: nil)
    let didSendMessage = BehaviorSubject<Bool>(value: false)
    let socketService: ChatSocketServiceType
    
    private let otherUser: User
    private var messages: Results<Message>!
    private var messagesNotificationToken: NotificationToken?
    
    init?(otherUserId: UUID, socketService: ChatSocketServiceType) {
        self.socketService = socketService
        do {
            let realm = try Realm()
            if let result = realm.object(ofType: User.self, forPrimaryKey: otherUserId) {
                otherUser = result
            } else {
                return nil
            }
            
            messages = realm.objects(Message.self)
                .where { $0.fromUserId == otherUser.id || $0.toUserId == otherUser.id }
                .sorted(by: \.sentAt, ascending: true)

        } catch {
            Logger.log(error.localizedDescription, type: .error)
            return nil
        }
    }
    
    func sendNewMessage(_ message: String) {
        guard let currentUserId = UserSession.shared?.currentUserId else {
            return
        }
        
        let newMessage = Message(
            id: UUID(),
            fromUserId: currentUserId,
            toUserId: otherUser.id,
            body: message,
            sentAt: Date(),
            wasInserted: false
        )
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(newMessage)
        }
    
        didSendMessage.onNext(true)
        socketService.deliverMessage(messageId: newMessage.id)
    }
    
    func viewDidEndDisplayingCell(with cellViewModel: ChatMessageCellViewModel) {
        if cellViewModel.isTemporary {
            let realm = try! Realm()
            try! realm.write {
                realm.object(ofType: Message.self, forPrimaryKey: cellViewModel.id)?.wasInserted = true
            }
        }
        
        if cellViewModel.isIncoming, !cellViewModel.isRead {
            socketService.markMessageAsRead(messageId: cellViewModel.id)
        }
    }
    
    func beginUpdates() {
        let realm = try! Realm()
        messages = realm.objects(Message.self)
            .where { $0.fromUserId == otherUser.id || $0.toUserId == otherUser.id }
            .sorted(by: \.sentAt, ascending: true)
        
        messagesNotificationToken = messages.observe(on: .main, { [weak self] change in
            switch change {
            case .initial(_):
                self?.reloadData()
            case .update(_, _, let insertions, _):
                self?.reloadData(hasInsertions: !insertions.isEmpty)
            default:
                break
            }
        })
    }
    
    var otherUserName: String {
        otherUser.firstName
    }
}

// MARK: - Private

private extension ChatViewModel {
    func reloadData(hasInsertions: Bool = false) {
        let results = Array(messages)
            
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none

        var cellViewModels: [ChatCellViewModel] = []
        var prev: Message?
        
        let initialMessage = try? initialMessageUpdate.value()
        if initialMessage == nil, let matchedAt = otherUser.matchedAt {
            initialMessageUpdate.onNext(
                .system(
                    ChatSystemMessageCellViewModel(
                        id: UUID(),
                        dateString: dateFormatter.string(from: matchedAt),
                        timeString: timeFormatter.string(from: matchedAt)
                    )
                )
            )
        }
        
        for message in results {
            let isSameSender = prev?.fromUserId == message.fromUserId
            
            let groupingRule: ChatMessageGroupingRule = .rule(
                forOlderMessageDate: prev?.sentAt ?? otherUser.matchedAt,
                newerMessageDate: message.sentAt,
                isSameSender: isSameSender)
            
            cellViewModels.append(
                ChatCellViewModel.user(
                    ChatMessageCellViewModel(
                        id: message.id,
                        message: message.body,
                        isIncoming: message.fromUserId == self.otherUser.id,
                        dateString: dateFormatter.string(from: message.sentAt),
                        timeString: timeFormatter.string(from: message.sentAt),
                        groupingRule: groupingRule,
                        isRead: message.readAt != nil,
                        isDelivered: message.deliveredAt != nil,
                        isTemporary: !message.wasInserted
                    )
                )
            )
            
            prev = message
        }
        
        messagesUpdate.onNext((cellViewModels.reversed(), hasInsertions))
    }
}
