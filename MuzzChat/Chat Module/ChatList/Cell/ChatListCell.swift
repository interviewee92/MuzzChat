//
//  ChatListCell.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import SwiftUI

struct ChatListCell: View {
    let viewModel: ChatListCellViewModel

    var body: some View {
        HStack {
            AsyncImage(url: viewModel.photoUrl) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 44.0, height: 44.0)
            } placeholder: {
                Image(.icProfilePhotoPlaceholderFemale)
                    .resizable()
                    .frame(width: 44.0, height: 44.0)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(viewModel.displayName)
                    .font(.headline)
                Text(viewModel.lastMessage ?? ("🎈" + NSLocalizedString("text-you-matched", comment: "")))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.leading, .padding)

            Spacer()
            
            Image(systemName: UIApplication.isRTL ? "chevron.left" : "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

// Preview

struct ChatListCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatListCell(viewModel: .init(user: User.mockCurrentUser, lastMessage: "🎈" + NSLocalizedString("text-you-matched", comment: "")))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
