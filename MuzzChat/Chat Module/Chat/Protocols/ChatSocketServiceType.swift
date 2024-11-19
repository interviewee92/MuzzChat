//
//  Untitled.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 09/10/2024.
//

import Foundation

protocol ChatSocketServiceType {
    init(userId: UUID)
    func deliverMessage(messageId: UUID)
    func markMessageAsRead(messageId: UUID)
}
