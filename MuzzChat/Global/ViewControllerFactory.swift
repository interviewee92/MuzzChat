//
//  ViewControllerFactory.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 10/10/2024.
//

import SwiftUI
import UIKit

final class ViewControllerFactory {
    
    func createChatListController(coordinator: Coordinator) -> UIViewController? {
        guard let coordinator = coordinator as? ChatCoordinator else {
            Logger.log("Invalid coordinator class!", type: .error)
            return nil
        }
        let chatViewModel = ChatListViewModel(coordinator: coordinator)
        let chatListController = ChatListController(viewModel: chatViewModel)
        
        return chatListController
    }
    
    func createChatTabController(userId: UUID) throws -> UIViewController {
        let chatTab = ChatTabView.Tab(view: try createChatTab(userId: userId), title: NSLocalizedString("chat-tab-chat", comment: ""))
        let profileTab = ChatTabView.Tab(view: createChatProfileTab(), title: NSLocalizedString("chat-tab-profile", comment: ""))

        let tabViewModel = ChatTabViewModel(otherUserId: userId)
        let chatTabController = ChatTabController(
            viewModel: tabViewModel,
            tabs: [chatTab, profileTab]
        )
        
        chatTabController.prerender()
        return chatTabController
    }
    
    func createChatTab(userId: UUID) throws -> AnyView {
        let socketService = SimulatedChatSocketService(userId: userId)
        
        guard let viewModel = ChatViewModel(otherUserId: userId, socketService: socketService) else {
            throw NSError(domain: NSLocalizedString("error-user-not-found", comment: ""), code: 1)
        }
        
        return AnyView(ChatViewController(viewModel: viewModel).asViewRepresentable)
    }
    
    func createChatProfileTab() -> AnyView {
        AnyView(ProfileView())
    }
}
