//
//  ChatListView.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import SwiftUI

struct ChatListView: View {
    @StateObject var viewModel: ChatListViewModel

    var body: some View {
        List(viewModel.cellViewModels, id: \.id) { cellViewModel in
            Button(action: {
                viewModel.openChat(for: cellViewModel)
            }) {
                ChatListCell(viewModel: cellViewModel)
            }
            
        }
        .listStyle(.plain)
        .navigationTitle("chat-list-screen-title")
        .navigationBarTitleDisplayMode(.large)
    }
}

// Preview for ChatListView
struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatListView(viewModel: ChatListViewModel())
        }
    }
}
