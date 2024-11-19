//
//  RealmManager.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    private var isSetUp = false
    
    private init() {}
    
    func setUpRealm() throws {
        if isSetUp { return }
        
        let config = Realm.Configuration(schemaVersion: 7)
        
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try Realm()
        
        try realm.write {
            realm.deleteAll()
            realm.add(User.mockCurrentUser, update: .all)
            realm.add(User.mockMatches, update: .all)
            realm.add(Message.mockMessages, update: .all)
        }
        
        isSetUp = true
    }
}
