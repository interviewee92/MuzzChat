//
//  ChatMessageCellViewModel.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import Foundation

struct ChatMessageCellViewModel: Hashable {
    
    let id: UUID
    let message: String
    let isIncoming: Bool
    var dateString: String? = nil
    var timeString: String? = nil
    let groupingRule: ChatMessageGroupingRule
    
    let isRead: Bool
    let isDelivered: Bool
    
    var isTemporary: Bool = false
}
