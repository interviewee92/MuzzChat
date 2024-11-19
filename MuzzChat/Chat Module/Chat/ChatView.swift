//
//  ChatView.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 03/10/2024.
//

import UIKit

final class ChatView: UIView {
    
    var onSendPressed: ((String) -> Void)?
    
    private(set) weak var tableView: UITableView!
    private(set) weak var sendButton: UIButton!
    private(set) weak var inputTextView: ChatMessageTextView!
    
    private weak var placeholderLabel: UILabel!
    private weak var inputContainerView: UIView!
    private weak var inputStackView: UIStackView!

    
    private let buttonSize: CGFloat = 44.0
    private let inputButtonSpacing: CGFloat = 0
    private let inputInset: CGFloat = .padding(x: 2)
    private let stackViewLayoutMargins = UIEdgeInsets(top: 0, left: .padding, bottom: 0, right: 0)
    
    lazy var inputWidth: CGFloat = {
        CGRect.screenRect.width - buttonSize - 2 * inputInset - inputButtonSpacing - stackViewLayoutMargins.left
    }()
    
    lazy var minimumInputHeight: CGFloat = {
        ChatMessageTextView.minimumHeight
    }()
    
    private(set) var inputTextViewHeight: NSLayoutConstraint?
    
    var inputPlaceholder: String {
        set {
            placeholderLabel.text = newValue
        }
        get {
            placeholderLabel.text ?? ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatView {
    func dequeueUserMessageCell(for indexPath: IndexPath, messageViewModel viewModel: ChatMessageCellViewModel) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.reuseIdentifier, for: indexPath) as? ChatMessageCell
        var size = ChatMessageTextView.calculateHeight(text: viewModel.message, maxWidth: self.inputWidth)
        size.width = max(size.width, self.minimumInputHeight)
        
        cell?.transform = CGAffineTransformMakeScale(1, -1)
        cell?.configure(with: viewModel, textViewSize: size)
        
        return cell
    }
    
    func dequeueSystemMessageCell(for indexPath: IndexPath, messageViewModel viewModel: ChatSystemMessageCellViewModel) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatSystemMessageCell.reuseIdentifier, for: indexPath) as? ChatSystemMessageCell
        
        cell?.transform = CGAffineTransformMakeScale(1, -1)
        cell?.configure(with: viewModel)
        
        return cell
    }
    
    func animateInsertion(of item: ChatMessageCellViewModel, toCell cell: UITableViewCell) {
        guard item.isTemporary, let cell = cell as? ChatMessageCell, let rect = inputTextView.superview?.convert(inputTextView.frame, to: self) else { return }
        
        var frame = rect
        frame.size = ChatMessageTextView.calculateHeight(text: item.message, maxWidth: self.inputWidth)
        frame.size.width = max(frame.size.width, minimumInputHeight)
        
        let viewToFadeIn = getTemporaryMessageTextView(for: item, frame: frame, style: .outgoingMessage)
        let viewToFadeOut = getTemporaryMessageTextView(for: item, frame: frame, style: .input)
        
        addSubview(viewToFadeIn)
        addSubview(viewToFadeOut)
        
        cell.animateInsert(
            fadeInView: viewToFadeIn,
            fadeOutView: viewToFadeOut,
            tableViewBottomInset: tableView.contentInset.bottom,
            tableViewFrameInSuperView: convert(tableView.frame, to: self)
        )
    }
    
    func completeSendingMessage() {
        inputTextView.text = nil
        inputTextView.reloadAppearance()
        updateTextViewHeight(forceClose: true)
        reloadSendButton(animated: true)
    }
    
    func prepareMessage() -> String {
        inputTextView.text = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        updateTextViewHeight(animated: false)
    
        return inputTextView.text
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
}

extension ChatView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        tableView.setContentOffset(.init(x: 0, y: -tableView.contentInset.top), animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
        reloadSendButton()
    }
}

private extension ChatView {
    
    var canSendMessage: Bool {
        !inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func reloadSendButton(animated: Bool = true) {
        
        sendButton.isUserInteractionEnabled = canSendMessage
        UIView.animate(withDuration: animated ? 0.2 : 0.0) {
            self.sendButton.layer.opacity = self.canSendMessage ? 1 : 0
            self.sendButton.transform = self.canSendMessage ? .identity : CGAffineTransformMakeScale(0.1, 0.1)
        }
    }
    
    func setupView(frame: CGRect) {
        backgroundColor = .muzzLightBackground
        
        configureSubviews()
        
        inputTextView.delegate = self
        
        tableView.register(ChatSystemMessageCell.self, forCellReuseIdentifier: ChatSystemMessageCell.reuseIdentifier)
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.reuseIdentifier)
        tableView.transform = CGAffineTransformMakeScale(1, -1)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(vertical: .padding(x: 2))
        tableView.allowsSelection = false
    }
    
    func getTemporaryMessageTextView(for viewModel: ChatMessageCellViewModel, frame: CGRect, style: ChatMessageTextView.Style) -> ChatMessageTextView {
        let view = ChatMessageTextView()
        view.text = viewModel.message
        view.style = style
        view.frame = frame
        view.setNeedsDisplay()
        view.layoutIfNeeded()
        return view
    }
    
    func configureSubviews() {
        
        let tableView = UITableView(frame: frame)
        tableView.backgroundColor = .muzzLightBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        let inputContainerView = UIView()
        inputContainerView.backgroundColor = .muzzLightBackground
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addShadow(position: .top)
        addSubview(inputContainerView)
        
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        
        inputContainerView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 100.0).isActive = true
        inputContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        inputContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        inputContainerView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let keyboardConstraint = inputContainerView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        keyboardConstraint.priority = .defaultHigh
        keyboardConstraint.isActive = true
                
        let inputTextView = ChatMessageTextView()
        inputTextView.style = .input
        inputTextView.textAlignment = .leading
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.textColor = .lightGray
        inputTextView.layer.maskedCorners = CACornerMask()
        inputTextView.returnKeyType = .default
        
        inputTextViewHeight = inputTextView.heightAnchor.constraint(equalToConstant: minimumInputHeight)
        inputTextViewHeight?.priority = .defaultHigh
        inputTextViewHeight?.isActive = true

        let sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
        sendButton.layer.opacity = 0
        sendButton.isUserInteractionEnabled = false
        sendButton.tintColor = .muzzPink

        sendButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true

        let placeholderLabel = UILabel()
        placeholderLabel.textAlignment = .leading
        placeholderLabel.font = inputTextView.font
        placeholderLabel.textColor = .muzzInputPlaceholder
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(placeholderLabel)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .bottom
        stackView.axis = .horizontal
        stackView.spacing = inputButtonSpacing
        stackView.distribution = .fill
        stackView.layer.borderColor = UIColor.muzzInputBorder.cgColor
        stackView.layer.borderWidth = 1.0
        stackView.layer.cornerRadius = 0.5 * minimumInputHeight
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = stackViewLayoutMargins
        
        inputContainerView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: .padding).isActive = true
        stackView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: inputInset).isActive = true
        stackView.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -inputInset).isActive = true
        stackView.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -.padding).isActive = true
        
        stackView.addArrangedSubview(inputTextView)
        stackView.addArrangedSubview(sendButton)
        
        placeholderLabel.centerYAnchor.constraint(equalTo: inputTextView.centerYAnchor).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: inputTextView.leadingAnchor, constant: inputTextView.layoutMargins.left).isActive = true
        
        self.tableView = tableView
        self.inputStackView = stackView
        self.sendButton = sendButton
        self.inputTextView = inputTextView
        self.inputContainerView = inputContainerView
        self.placeholderLabel = placeholderLabel
    }
    
    func updateTextViewHeight(forceClose: Bool = false, animated: Bool = true) {
        inputTextView.reloadAppearance()
        
        inputTextView.isScrollEnabled = false
        let size = inputTextView.sizeThatFits(CGSize(width: inputTextView.frame.width, height: .hugeNumber))
        inputTextView.isScrollEnabled = true
        
        let height = max(minimumInputHeight, size.height)
        inputTextViewHeight?.constant = inputTextView.text.isEmpty || forceClose ? minimumInputHeight : height
        
        placeholderLabel.isHidden = !inputTextView.text.isEmpty
        
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}
