//
//  ChatTabViewModel.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 08/10/2024.
//

import Foundation
import RealmSwift

final class ChatTabViewModel {

    private(set) var otherUserId: UUID
    private(set) var otherUserPhotoUrl: URL?
    private(set) var otherUserName: String?
    
    init(otherUserId: UUID) {
        self.otherUserId = otherUserId
        fetchUser()
    }
    
    func fetchUser() {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: otherUserId)
            otherUserName = user?.displayName
            otherUserPhotoUrl = user?.photoUrl
        } catch {

        }
    }
}
