//
//  ChatListViewModel.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import Foundation
import RealmSwift

final class ChatListViewModel: ObservableObject {
    @Published var cellViewModels: [ChatListCellViewModel] = []
    private weak var coordinator: ChatCoordinator?
    
    init(coordinator: ChatCoordinator? = nil) {
        self.coordinator = coordinator
        
        fetchData()
    }
    
    func openChat(for cellViewModel: ChatListCellViewModel) {
        coordinator?.openChatWithUser(withId: cellViewModel.id)
    }
    
    // MARK: - Private

    private func fetchData() {
        guard let session = UserSession.shared else { return }

        let realm = try! Realm()
        let results = realm.objects(User.self).where { $0.id != session.currentUserId }

        self.cellViewModels = results.map {
            let lastMessage = lastMessage(with: $0)
            return ChatListCellViewModel(user: $0, lastMessage: lastMessage?.body)
        }
    }
    
    private func lastMessage(with user: User) -> Message? {
        let realm = try! Realm()
        let result = realm
            .objects(Message.self)
            .where { $0.fromUserId == user.id || $0.toUserId == user.id }
            .sorted(by: \.sentAt, ascending: false)
            .first
        
        return result
    }
}
