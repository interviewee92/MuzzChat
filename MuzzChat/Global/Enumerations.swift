//
//  Enumerations.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 09/10/2024.
//

import Foundation

enum ChatMessageGroupingRule {
    case sameGroup, differentGroup, differentSection
    
    static func rule(forOlderMessageDate olderMessageDate: Date?, newerMessageDate: Date, isSameSender: Bool) -> ChatMessageGroupingRule {
        if let olderMessageDate = olderMessageDate {

            let timeDiff = newerMessageDate.timeIntervalSince(olderMessageDate)

            if isSameSender, timeDiff < 20 {
                return .sameGroup
            } else if timeDiff < 60 * 60 {
                return .differentGroup
            }
        }
        
        return .differentSection
    }
}
