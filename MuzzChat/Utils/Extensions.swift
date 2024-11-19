//
//  Extensions.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 03/10/2024.
//

import UIKit

extension UIApplication {
    static var isRTL: Bool {
        UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}

extension CGRect {
    static let screenRect = UIScreen.main.bounds
}

extension CGFloat {
    // Added, because .greatestFiniteMagnitude procudes tons of debugger warnings
    static let hugeNumber: CGFloat = 999_999_999
}

extension UIEdgeInsets {
    init(padding: CGFloat) {
        self.init(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

extension Character {
    var isEmoji: Bool {
        return isSimpleEmoji || isCombinedIntoEmoji
    }
    
    private var isSimpleEmoji: Bool {
        return unicodeScalars.count == 1 && unicodeScalars.first?.properties.isEmojiPresentation ?? false
    }
    
    private var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 &&
        unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector || $0.properties.isEmojiModifier }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension NSTextAlignment {
    static var leading: NSTextAlignment {
        if UIApplication.isRTL {
            return .right
        } else {
            return .left
        }
    }
    
    static var trailing: NSTextAlignment {
        if UIApplication.isRTL {
            return .left
        } else {
            return .right
        }
    }
}

extension UIViewController {
    func presentInfoAlert(message: String) {
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(
            .init(title: "Ok", style: .default)
        )
        
        present(alert, animated: true)
    }
    
    func prerender() {
        if parent != nil { return }
        
        let window = UIWindow(frame: .screenRect)
        window.rootViewController = UINavigationController(rootViewController: self)
        window.isHidden = false
        window.layer.opacity = 0
        window.layoutIfNeeded()
        
        self.removeFromParent()
    }
}

extension Optional where Wrapped: Collection {
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}
