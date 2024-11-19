//
//  ChatMessageTextView.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 07/10/2024.
//

import UIKit

final class ChatMessageTextView: UITextView {
    
    enum Style {
        case input, incomingMessage, outgoingMessage
    }
    
    override var text: String! {
        didSet {
            reloadAppearance()
        }
    }
    
    var style: Style = .input {
        didSet {
            reloadAppearance()
        }
    }
    
    var isEmojiFormatted: Bool {
        !text.isEmpty && text.count <= 3 && !text.contains(where: { !$0.isEmoji })
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        textAlignment = .leading
        textContainerInset = UIEdgeInsets(padding: .padding * 1.5)
        layer.cornerRadius = 16.0
        style = .input
    }
    
    func reloadAppearance() {
        font = .preferredFont(forTextStyle: .subheadline)
        textContainer.lineFragmentPadding = 0
        
        let isRTL = UIApplication.isRTL
        let cornersPointingLeft: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        let cornersPointingRight: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        
        switch style {
        case .input:
            layer.maskedCorners = isRTL ? cornersPointingLeft : cornersPointingRight
            backgroundColor = .clear
            textColor = .muzzDarkGrayText
        case .incomingMessage:
            layer.maskedCorners = !isRTL ? cornersPointingLeft : cornersPointingRight
            backgroundColor = .muzzOtherMessageBackground
            textColor = .muzzOtherMessageText
            textAlignment = .leading
        case .outgoingMessage:
            layer.maskedCorners = isRTL ? cornersPointingLeft : cornersPointingRight
            backgroundColor = .muzzPink
            textColor = .muzzLightText
            textAlignment = isEmojiFormatted ? .trailing : .leading
        }
        
        if isEmojiFormatted {
            font = .preferredFont(forTextStyle: .extraLargeTitle)
            layoutMargins = .zero
            backgroundColor = .clear
        } else {
            layoutMargins = UIEdgeInsets(padding: .padding * 1.5)
        }
        
        setNeedsDisplay()
        layoutIfNeeded()
    }
    
    static func calculateHeight(text: String, maxWidth: CGFloat) -> CGSize {
        let offscreenTextView = ChatMessageTextView()
        offscreenTextView.isScrollEnabled = false
        offscreenTextView.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return offscreenTextView.sizeThatFits(CGSize(width: maxWidth, height: .hugeNumber))
    }
    
    static var minimumHeight: CGFloat {
        ChatMessageTextView.calculateHeight(text: ".", maxWidth: .hugeNumber).height
    }
}
