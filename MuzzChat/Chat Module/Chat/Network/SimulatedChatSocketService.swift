//
//  SimulatedChatSocketService.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 09/10/2024.
//

import RealmSwift

class SimulatedChatSocketService: ChatSocketServiceType {
    
    private let otherUserId: UUID
    
    required init(userId otherUserId: UUID) {
        self.otherUserId = otherUserId
    }
    
    func deliverMessage(messageId: UUID) {
        Task(priority: .background) { [weak self] in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            autoreleasepool {
                let realm = try! Realm()
                if let message = realm.object(ofType: Message.self, forPrimaryKey: messageId) {
                    try? realm.write {
                        message.deliveredAt = Date()
                    }
                    
                    self?.simulateReadMessage(to: message.id)
                }
            }
        }
    }
    
    func markMessageAsRead(messageId: UUID) {
        Task(priority: .background) {
            autoreleasepool {
                let realm = try! Realm()
                if let message = realm.object(ofType: Message.self, forPrimaryKey: messageId) {
                    try? realm.write {
                        message.readAt = Date()
                    }
                }
            }
        }
    }
    
    private func simulateReadMessage(to messageId: UUID) {
        Task(priority: .background) { [weak self] in
            let delay = UInt64.random(in: 1...2)
            try? await Task.sleep(nanoseconds: delay * 1_000_000_000)
            
            autoreleasepool {
                let realm = try! Realm()
                if let message = realm.object(ofType: Message.self, forPrimaryKey: messageId) {
                    try? realm.write {
                        message.readAt = Date()
                    }
                }
            }
            
            self?.simulateResponse()
        }
    }
    
    private func simulateResponse(probabilityOfFollowingResponse: Int = 80) {
        Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            let delay = UInt64.random(in: 1...3)
            try? await Task.sleep(nanoseconds: delay * 1_000_000_000)
            
            if Int.random(in: 1...100) < probabilityOfFollowingResponse {
                autoreleasepool {
                    let realm = try! Realm()
                    try! realm.write {
                        let response = Message(
                            id: UUID(),
                            fromUserId: self.otherUserId,
                            toUserId: UserSession.shared!.currentUserId,
                            body: Message.mockResponses[Int.random(in: 0..<Message.mockResponses.count)],
                            sentAt: Date(),
                            deliveredAt: Date()
                        )
                        
                        realm.add(response)
                    }
                    
                    self.simulateResponse(probabilityOfFollowingResponse: probabilityOfFollowingResponse - 15)
                }
            }
        }
    }
}
