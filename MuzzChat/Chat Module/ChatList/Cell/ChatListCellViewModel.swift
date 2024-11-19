//
//  ChatListCellViewModel.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import Foundation

struct ChatListCellViewModel {
    let id: UUID
    let displayName: String
    let photoUrl: URL?
    let lastMessage: String?
    
    init(user: User, lastMessage: String?) {
        self.id = user.id
        self.displayName = user.displayName
        self.photoUrl = user.photoUrl
        self.lastMessage = lastMessage
    }
}
