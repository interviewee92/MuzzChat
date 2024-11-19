//
//  User.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import Foundation
import RealmSwift

final class User: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var photoUrlString: String?
    @Persisted var matchedAt: Date?
    
    convenience init(id: UUID, firstName: String, lastName: String, photoUrl: URL? = nil, matchedAt: Date? = nil) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.photoUrlString = photoUrl?.absoluteString
        self.matchedAt = matchedAt
    }
    
    var displayName: String {
        [firstName, lastName].joined(separator: " ")
    }
    
    var photoUrl: URL? {
        return URL(string: photoUrlString ?? "")
    }
}
