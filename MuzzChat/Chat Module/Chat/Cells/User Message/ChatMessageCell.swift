//
//  ChatMessageCell.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 03/10/2024.
//

import UIKit

final class ChatMessageCell: UITableViewCell {
    
    static let reuseIdentifier: String = String(describing: ChatMessageCell.self) + "-ReuseIdentifier"
    
    private weak var textView: ChatMessageTextView!
    private weak var stackView: UIStackView!
    private weak var statusImageView: UIImageView!
    private weak var dateLabel: UILabel!
    
    private var textViewHeight: NSLayoutConstraint?
    private var textViewWidth: NSLayoutConstraint?
    
    private var viewModel: ChatMessageCellViewModel?
    private var textViewSize: CGSize?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellViewModel: ChatMessageCellViewModel, textViewSize: CGSize) {
        self.viewModel = cellViewModel
        self.textViewSize = textViewSize
        
        textView.text = cellViewModel.message
        textView.style = cellViewModel.isIncoming ? .incomingMessage : .outgoingMessage
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        
        let hPadding: CGFloat = textView.isEmojiFormatted ? 0 : cellViewModel.isIncoming ? .padding(x: 2) : .padding
        stackView.layoutMargins = UIEdgeInsets(top: topPadding, left: hPadding, bottom: 0, right: hPadding)
        stackView.alignment = cellViewModel.isIncoming ? .leading : .trailing
        stackView.spacing = textView.isEmojiFormatted ? 0 : .padding
        
        if textViewWidth == nil {
            textViewWidth = textView.widthAnchor.constraint(equalToConstant: textViewSize.width)
            textViewWidth?.priority = .defaultHigh
            textViewWidth?.isActive = true
        } else {
            textViewWidth?.constant = textViewSize.width
        }
        
        if textViewHeight == nil {
            textViewHeight = textView.heightAnchor.constraint(equalToConstant: textViewSize.height)
            textViewHeight?.priority = .defaultHigh
            textViewHeight?.isActive = true
        } else {
            textViewHeight?.constant = textViewSize.height
        }
        
        statusImageView.isHidden = cellViewModel.isIncoming
        
        if cellViewModel.isRead {
            statusImageView.image = UIImage(named: "ic-message-status-read")?.withRenderingMode(.alwaysTemplate)
        } else if cellViewModel.isDelivered {
            statusImageView.image = UIImage(named: "ic-message-status-delivered")?.withRenderingMode(.alwaysTemplate)
        } else {
            statusImageView.image = nil
        }
        
        statusImageView.tintColor = textView.isEmojiFormatted ? .muzzNavigationBarTint : .white
        dateLabel.isHidden = cellViewModel.groupingRule != .differentSection
        dateLabel.attributedText = dateAttributedString

        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func animateInsert(
        fadeInView: ChatMessageTextView,
        fadeOutView: ChatMessageTextView,
        tableViewBottomInset: CGFloat,
        tableViewFrameInSuperView: CGRect)
    {
        self.textView.alpha = 0.0
        
        let offset = fadeInView.frame.height - minimumTextViewHeight
        let initialPosition = CGPoint(x: fadeInView.frame.midX, y: fadeInView.frame.midY)
        
        let finalPosition: CGPoint

        if UIApplication.isRTL {
            finalPosition = CGPoint(
                x: (fadeInView.frame.width * 0.5) + stackView.layoutMargins.right,
                y: tableViewFrameInSuperView.maxY + -fadeInView.frame.height * 0.5 - tableViewBottomInset + offset)
        } else {
            finalPosition = CGPoint(
                x: tableViewFrameInSuperView.width - (fadeInView.frame.width * 0.5) - stackView.layoutMargins.right,
                y: tableViewFrameInSuperView.maxY + -fadeInView.frame.height * 0.5 - tableViewBottomInset + offset)
        }
        
        applyInsertAnimation(to: fadeInView, duration: 0.3, initialPosition: initialPosition, finalPosition: finalPosition)
        applyInsertAnimation(to: fadeOutView, duration: 0.3, initialPosition: initialPosition, finalPosition: finalPosition)
        
        fadeInView.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            fadeInView.alpha = 1.0
            fadeOutView.alpha = 0.0
        } completion: { _ in
            fadeOutView.removeFromSuperview()
            
            self.stackView.addArrangedSubview(fadeInView)
            self.textViewWidth = nil
            self.textViewHeight = nil
            
            self.textView.removeFromSuperview()
            self.textView = fadeInView
            
            self.configure(with: self.viewModel!, textViewSize: self.textViewSize!)
        }
    }
    
    private lazy var minimumTextViewHeight: CGFloat = {
        ChatMessageTextView.minimumHeight
    }()
}

private extension ChatMessageCell {
    
    var dateAttributedString: NSAttributedString? {
        guard let date = viewModel?.dateString, let time = viewModel?.timeString else {
            return nil
        }
        
        let retVal = NSMutableAttributedString()
        
        retVal.append(.init(string: date, attributes: [.foregroundColor: UIColor.muzzGrayText, .font: UIFont.systemFont(ofSize: 13, weight: .heavy)]))
        retVal.append(.init(string: " ", attributes: [.foregroundColor: UIColor.muzzGrayText, .font: UIFont.systemFont(ofSize: 13)]))
        retVal.append(.init(string: time, attributes: [.foregroundColor: UIColor.muzzGrayText, .font: UIFont.systemFont(ofSize: 13)]))
        
        return retVal
    }
    
    var topPadding: CGFloat {
        switch viewModel?.groupingRule {
        case .sameGroup: return 0.5 * CGFloat.padding
        case .differentGroup: return 2.0 * CGFloat.padding
        case .differentSection: return 3.0 * CGFloat.padding
        case nil: return .padding
        }
    }
}

private extension ChatMessageCell {
    
    func setUp() {
        setUpSubiews()
        setUpConstraints()
    }
    
    func setUpSubiews() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .trailing
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(padding: .padding)
        stackView.spacing = .padding
        contentView.addSubview(stackView)
        self.stackView = stackView

        let textView = ChatMessageTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 16.0
        textView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.textView = textView
        
        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.isHidden = true
        self.dateLabel = dateLabel
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(textView)

        let statusImageView = UIImageView()
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusImageView)
        self.statusImageView = statusImageView
    }
    
    func setUpConstraints() {
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        let labelWidth = dateLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        labelWidth.priority = .defaultHigh
        labelWidth.isActive = true
        
        statusImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -.padding * 1.5).isActive = true
        statusImageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0.5 * -.padding).isActive = true
    }
    
    func applyInsertAnimation(to view: UIView, duration: TimeInterval, initialPosition: CGPoint, finalPosition: CGPoint) {
        let controlPoint = CGPoint(x: finalPosition.x, y: initialPosition.y)

        if textView.isEmojiFormatted {
            view.backgroundColor = .clear
        }
        
        let path = UIBezierPath()
        path.move(to: initialPosition)
        path.addCurve(
            to: finalPosition,
            controlPoint1: controlPoint,
            controlPoint2: controlPoint
        )
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = .backwards
        animation.isRemovedOnCompletion = false
        
        view.layer.add(animation, forKey: "curvyAnimation")
        view.layer.position = finalPosition
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.8
        scaleAnimation.duration = 0.2
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = 1
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        view.layer.add(animation, forKey: "curvyAnimation")
        view.layer.add(scaleAnimation, forKey: "scaleAnimation")

        view.layer.position = finalPosition
    }
}
