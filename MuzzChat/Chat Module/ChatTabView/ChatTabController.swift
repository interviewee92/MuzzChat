//
//  ChatTabController.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 08/10/2024.
//

import SwiftUI
import UIKit
import Kingfisher

final class ChatTabController: UIHostingController<ChatTabView> {

    private let viewModel: ChatTabViewModel
    
    init(viewModel: ChatTabViewModel, tabs: [ChatTabView.Tab]) {
        self.viewModel = viewModel
        let chatTabView = ChatTabView(tabs: tabs)
        super.init(rootView: chatTabView)
        configureNavigationItem()
    }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChatTabController {
    func configureNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let barButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic-nav-menu"),
            style: .plain,
            target: self,
            action: nil
        )

        navigationItem.setRightBarButton(barButtonItem, animated: true)
        
        if let name = viewModel.otherUserName {
            let titleView = ImageTitleView()
            titleView.titleLabel.text = name
            titleView.sizeToFit()
            navigationItem.titleView = titleView
            
            if let url = viewModel.otherUserPhotoUrl {
                titleView.imageView.kf.setImage(with: url)
            }
        }
    }
}
