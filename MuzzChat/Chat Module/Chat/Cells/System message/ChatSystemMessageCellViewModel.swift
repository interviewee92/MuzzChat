//
//  ChatSystemMessageCellViewModel.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 10/10/2024.
//

import UIKit

struct ChatSystemMessageCellViewModel: Hashable {
    let id: UUID
    let dateString: String
    let timeString: String
    
    var attributedMessage: NSAttributedString {
        let font = UIFont(name: "DMSerifText-Regular", size: 24.0)!
        let retVal = NSMutableAttributedString()
        retVal.append(.init(string: "🎈", attributes: [.font: UIFont.preferredFont(forTextStyle: .extraLargeTitle)]))
        retVal.append(.init(string: "\n", attributes: [.font: font]))
        retVal.append(.init(string: NSLocalizedString("text-you-matched", comment: ""), attributes: [.foregroundColor: UIColor.muzzDarkGrayText, .font: font]))
        
        return retVal
    }
}
