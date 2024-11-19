//
//  ChatViewController.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 03/10/2024.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

enum ChatSection: CaseIterable {
    case system, messages
}

final class ChatViewController: UIViewController {
    
    let viewModel: ChatViewModelType
    private let chatView: ChatView!
    
    private(set) var dataSource: ChatDiffableDataSource!
    private let disposeBag = DisposeBag()
    
    init(viewModel: ChatViewModelType) {
        self.viewModel = viewModel
        self.chatView = ChatView(frame: .screenRect)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDataSource()
        bindView()
        bindViewModel()
        
        viewModel.beginUpdates()
    }
    
    // MARK: Required
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let .user(item) = dataSource.itemIdentifier(for: indexPath) {
            chatView.animateInsertion(of: item, toCell: cell)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        chatView.dismissKeyboard()
    }
}

private extension ChatViewController {
    
    func setUpDataSource() {
        dataSource = ChatDiffableDataSource(tableView: chatView.tableView) { [weak self] (tableView, indexPath, viewModel) -> UITableViewCell? in
            switch viewModel {
            case .system(let cellViewModel):
                return self?.chatView.dequeueSystemMessageCell(for: indexPath, messageViewModel: cellViewModel)
            case .user(let cellViewModel):
                return self?.chatView.dequeueUserMessageCell(for: indexPath, messageViewModel: cellViewModel)
            }
        }
        
        setUpDataSourceSections()
    }
    
    func setUpDataSourceSections() {
        var snapshot = NSDiffableDataSourceSnapshot<ChatSection, ChatCellViewModel>()
        snapshot.appendSections(ChatSection.allCases.reversed())
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func bindView() {
        chatView.tableView.delegate = self
        chatView.inputPlaceholder = String(format: NSLocalizedString("chat-input-placeholder", comment: ""), viewModel.otherUserName)
        
        chatView.sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let message = self?.chatView.prepareMessage(), !message.isEmpty {
                    self?.viewModel.sendNewMessage(message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        viewModel.didSendMessage
            .observe(on: MainScheduler.instance)
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.chatView.completeSendingMessage()
            })
            .disposed(by: disposeBag)
        
        viewModel.initialMessageUpdate
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe { [weak self] viewModel in
                guard let self = self else { return }
                
                var currentSnapshot = self.dataSource.snapshot()
                
                let oldValues = currentSnapshot.itemIdentifiers(inSection: .system)
                currentSnapshot.deleteItems(oldValues)
                currentSnapshot.appendItems([viewModel], toSection: .system)
                
                self.dataSource.apply(currentSnapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        viewModel.messagesUpdate
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] update in
                guard let self = self else { return }
                
                var currentSnapshot = self.dataSource.snapshot()
                let currentItems = currentSnapshot.itemIdentifiers(inSection: .messages)
                let updatedItems = update.messages
                currentSnapshot.deleteItems(currentItems)
                currentSnapshot.appendItems(updatedItems, toSection: .messages)
                
                self.dataSource.apply(currentSnapshot, animatingDifferences: update.shouldAnimate) {
                    updatedItems
                        .forEach {
                            if case let .user(cellViewModel) = $0 {
                                self.viewModel.viewDidEndDisplayingCell(with: cellViewModel)
                            }
                        }
                }
            })
            .disposed(by: disposeBag)
    }
}
