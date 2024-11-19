//
//  AppCoordinator.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import UIKit

class AppCoordinator: Coordinator, ParentCoordinator {
    var navigationController: UINavigationController

    private(set) var childCoordinators: [ChildCoordinator] = []

    private var rootCoordinator: ChildCoordinator?

    init() {
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
    }

    func start(animated: Bool) {
        let rootCoordinator = ChatCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )

        self.rootCoordinator = rootCoordinator
        
        addChild(rootCoordinator)
        rootCoordinator.start(animated: animated)
    }

    func addChild(_ coordinator: Coordinator & ChildCoordinator) {
        if childCoordinators.contains(where: { $0.navigationController == coordinator.navigationController }) {
            Logger.log("\(#file) - \(type(of: coordinator)) already added as chiild", type: .error)
            return
        }

        childCoordinators.append(coordinator)
    }
}
