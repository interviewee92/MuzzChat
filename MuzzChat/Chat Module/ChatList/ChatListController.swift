//
//  ChatListController.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 08/10/2024.
//

import SwiftUI
import UIKit

final class ChatListController: UIHostingController<ChatListView> {

    init(viewModel: ChatListViewModel) {
        let view = ChatListView(viewModel: viewModel)
        super.init(rootView: view)
        configureNavigationItem()
    }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChatListController {
    func configureNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
