//
//  ChatViewControllerRepresentable.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 09/10/2024.
//

import SwiftUI

struct ChatViewControllerRepresentable: UIViewControllerRepresentable {
    private let chatController: ChatViewController
    
    init(chatController: ChatViewController) {
        self.chatController = chatController
    }
    
    func makeUIViewController(context: Context) -> ChatViewController {
        return chatController
    }

    func updateUIViewController(_ uiViewController: ChatViewController, context: Context) {

    }
}

extension ChatViewController {
    var asViewRepresentable: any UIViewControllerRepresentable {
        ChatViewControllerRepresentable(chatController: self)
    }
}
