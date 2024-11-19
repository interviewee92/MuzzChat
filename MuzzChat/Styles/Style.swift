//
//  AppStyle.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import UIKit

class AppStyle {
    static func setNavigationBarAppearance() {
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil
        appearance.backgroundEffect = nil
        
        appearance.buttonAppearance = buttonAppearance
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        appearance.buttonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        let barAppearance = UINavigationBar.appearance()
        barAppearance.standardAppearance = appearance
        barAppearance.scrollEdgeAppearance = appearance
        barAppearance.compactAppearance = appearance
        barAppearance.tintColor = .gray
    }
}

// MARK: AppStyle related extensions

extension CGFloat {

    static let padding = 8.0

    static func padding(x: CGFloat) -> CGFloat {
        padding * x
    }
}
