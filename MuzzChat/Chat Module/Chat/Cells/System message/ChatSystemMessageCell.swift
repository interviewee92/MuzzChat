//
//  ChatSystemMessageCell.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 03/10/2024.
//

import UIKit

final class ChatSystemMessageCell: UITableViewCell {
    
    static let reuseIdentifier: String = String(describing: ChatSystemMessageCell.self) + "-ReuseIdentifier"
    
    private weak var stackView: UIStackView!
    private weak var messageLabel: UILabel!
    private weak var dateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellViewModel: ChatSystemMessageCellViewModel) {

        let dateAttributedString = NSMutableAttributedString()
        dateAttributedString.append(.init(string: cellViewModel.dateString, attributes: [.foregroundColor: UIColor.muzzGrayText, .font: UIFont.systemFont(ofSize: 13, weight: .heavy)]))
        dateAttributedString.append(.init(string: " ", attributes: [.foregroundColor: UIColor.muzzGrayText, .font: UIFont.systemFont(ofSize: 13)]))
        dateAttributedString.append(.init(string: cellViewModel.timeString, attributes: [.foregroundColor: UIColor.muzzGrayText, .font: UIFont.systemFont(ofSize: 13)]))
        
        dateLabel.attributedText = dateAttributedString
        messageLabel.attributedText = cellViewModel.attributedMessage

        setNeedsLayout()
        layoutIfNeeded()
    }
}

private extension ChatSystemMessageCell {
    
    func setUp() {

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(padding: .padding)
        stackView.spacing = .padding
        contentView.addSubview(stackView)
        self.stackView = stackView

        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel = dateLabel
        
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel = messageLabel
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(messageLabel)

        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
