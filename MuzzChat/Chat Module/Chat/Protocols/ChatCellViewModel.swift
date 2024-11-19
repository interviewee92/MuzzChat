//
//  ChatCellViewModel.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 10/10/2024.
//

import Foundation

enum ChatCellViewModel: Hashable {
    case system(ChatSystemMessageCellViewModel)
    case user(ChatMessageCellViewModel)

    var id: UUID {
        switch self {
        case .system(let viewModel):
            return viewModel.id
        case .user(let viewModel):
            return viewModel.id
        }
    }
    
    static func == (lhs: ChatCellViewModel, rhs: ChatCellViewModel) -> Bool {
        switch (lhs, rhs) {
        case (.system(let lvm), .system(let rvm)): return lvm.id == rvm.id && lvm.hashValue == rvm.hashValue
        case (.user(let lvm), .user(let rvm)): return lvm.id == rvm.id && lvm.hashValue == rvm.hashValue
        default: return false
        }
    }
}
