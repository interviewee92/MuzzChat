//
//  AppStyle.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import UIKit
import SwiftUI

final class AppStyle {
    static func setNavigationBarAppearance() {
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .muzzLightBackground
        appearance.shadowColor = nil
        appearance.backgroundEffect = nil
        
        appearance.buttonAppearance = buttonAppearance
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.muzzNavigationBarTint]
        appearance.buttonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.muzzDarkGrayText]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.muzzDarkGrayText]
        
        let barAppearance = UINavigationBar.appearance()
        barAppearance.standardAppearance = appearance
        barAppearance.scrollEdgeAppearance = appearance
        barAppearance.compactAppearance = appearance
        barAppearance.tintColor = .muzzNavigationBarTint
    }
}

enum ShadowPosition {
    case top, right, bottom, left, center
}

extension UIView {
    
    func addShadow(position: ShadowPosition = .center) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 6.0
        
        switch position {
        case .top:
            layer.shadowOffset = CGSize(width: 0, height: -6.0)
        case .right:
            layer.shadowOffset = CGSize(width: 6.0, height: 0)
        case .bottom:
            layer.shadowOffset = CGSize(width: 0, height: 6.0)
        case .left:
            layer.shadowOffset = CGSize(width: -6.0, height: 0)
        case .center:
            layer.shadowOffset = .zero
        }
    }
}

extension View {
    
    func shadow(position: ShadowPosition) -> some View {
        let view = UIView()
        view.addShadow(position: position)
        return self.shadow(
            color: Color(cgColor: view.layer.shadowColor ?? UIColor.clear.cgColor).opacity(Double(view.layer.shadowOpacity)),
            radius: view.layer.shadowRadius,
            x: view.layer.shadowOffset.width,
            y: view.layer.shadowOffset.height
        )
    }
}

// MARK: AppStyle related extensions

extension CGFloat {

    static let padding: CGFloat = 8.0

    static func padding(x: CGFloat) -> CGFloat {
        padding * x
    }
}
