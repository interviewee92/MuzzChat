//
//  Message.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import Foundation
import RealmSwift

final class Message: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var fromUserId: UUID
    @Persisted var toUserId: UUID
    @Persisted var body: String
    @Persisted(indexed: true) var sentAt: Date
    @Persisted var deliveredAt: Date?
    @Persisted var readAt: Date?
    @Persisted var wasInserted: Bool

    convenience init(
        id: UUID,
        fromUserId: UUID,
        toUserId: UUID,
        body: String,
        sentAt: Date,
        deliveredAt: Date? = nil,
        readAt: Date? = nil,
        wasInserted: Bool = true)
    {
        self.init()
        self.id = id
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.body = body
        self.sentAt = sentAt
        self.deliveredAt = deliveredAt
        self.readAt = readAt
        self.wasInserted = wasInserted
    }
}
