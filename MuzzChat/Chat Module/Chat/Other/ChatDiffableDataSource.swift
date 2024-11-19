//
//  ChatDiffableDataSource.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 09/10/2024.
//

import UIKit

class ChatDiffableDataSource: UITableViewDiffableDataSource<ChatSection, ChatCellViewModel> {
    override init(tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<ChatSection, ChatCellViewModel>.CellProvider) {
        super.init(tableView: tableView, cellProvider: cellProvider)
        defaultRowAnimation = .top
    }
}
