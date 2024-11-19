//
//  UserSession.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import Foundation
import RealmSwift

final class UserSession {
    
    static var shared: UserSession?
    
    private(set) var currentUserId: UUID
    
    init(userId: UUID) {
        self.currentUserId = userId
    }
}
