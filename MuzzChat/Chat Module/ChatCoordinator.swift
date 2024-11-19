//
//  CoinsCoordinator.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import UIKit

final class ChatCoordinator: Coordinator, ChildCoordinator {
    var navigationController: UINavigationController
    var rootViewContrller: UIViewController?

    private(set) weak var parentCoordinator: ParentCoordinator?
    private let controllerFactory = ViewControllerFactory()
    
    init(navigationController: UINavigationController,
         parentCoordinator: ParentCoordinator? = nil)
    {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }

    func start(animated: Bool) {
        if let rootViewContrller = rootViewContrller, navigationController.viewControllers.contains(rootViewContrller) {
            Logger.log("Coordinator has already started", type: .error)
            return
        }

        if let controller = controllerFactory.createChatListController(coordinator: self) {
            rootViewContrller = controller
            navigationController.pushViewController(controller, animated: animated)
        }
    }
    
    func openChatWithUser(withId id: UUID) {
        do {
            let tabController = try controllerFactory.createChatTabController(userId: id)
            navigationController.pushViewController(tabController, animated: true)
        } catch {
            navigationController.presentInfoAlert(message: error.localizedDescription)
        }
    }
}
