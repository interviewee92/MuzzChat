//
//  Mocks.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 05/10/2024.
//

import Foundation

// Mock users
extension User {
    static let mockCurrentUser: User = User(
        id: UUID(uuidString: "C5A1DA4A-F3D0-4B97-A69D-9F12569C1641")!,
        firstName: "John",
        lastName: "Doe",
        photoUrl: URL(string: "https://randomuser.me/api/portraits/men/4.jpg")
    )
    
    static let mockMatches: [User] = [
        User(
            id: UUID(uuidString: "A33B4C67-8A1E-4F20-8F87-DEF97C0F1D11")!,
            firstName: "Amina",
            lastName: "Khan",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/5.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "D94C5077-83D0-4B76-9A92-B237B31AE676")!,
            firstName: "Sofia",
            lastName: "Reyes",
            photoUrl: nil,
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-09T23:36:00Z")!
        ),
        User(
            id: UUID(uuidString: "C135D6A8-238D-42F7-8E89-FBF06A6B9B02")!,
            firstName: "Maya",
            lastName: "Patel",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/15.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "9F86D2B5-15A3-4B4C-B3F7-7E82A1C6F462")!,
            firstName: "Chloe",
            lastName: "Dubois",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/20.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "49343A38-36C0-48A8-872F-BC0D816B307E")!,
            firstName: "Fatima",
            lastName: "Ali",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/25.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "B7D823EA-167B-4720-96C4-6A3F7A73C1E8")!,
            firstName: "Emma",
            lastName: "Johnson",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/30.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "CD8B0DA9-44B0-40C6-8F1D-99B3D91E06D9")!,
            firstName: "Olivia",
            lastName: "Müller",
            photoUrl: nil,
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "2F9C4B98-1D7D-419B-BD0E-7DA92BC1E2E0")!,
            firstName: "Zara",
            lastName: "Ali",
            photoUrl: nil,
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "8F405B45-2A4D-4BFF-B42F-5BB8BB1C11F7")!,
            firstName: "Layla",
            lastName: "Garcia",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/45.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "0C5C1B30-2F54-45CA-BA6D-6F9A7E1A0E47")!,
            firstName: "Ava",
            lastName: "Wang",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/50.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "B99B11F1-BC90-4F15-B888-442F25FDF472")!,
            firstName: "Rania",
            lastName: "Bensalem",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/55.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "C60F5E2E-4B7C-4588-AB05-C62A2BAA45B7")!,
            firstName: "Sofia",
            lastName: "Martinez",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/60.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "1A0DAA79-88DA-445D-9D4D-4C6B7DAB0C9A")!,
            firstName: "Emily",
            lastName: "Wong",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/65.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "7394CC3B-DA0D-49C1-BCC2-5D8A0B74F6C7")!,
            firstName: "Chantal",
            lastName: "Lefevre",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/70.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "B226C92A-C7DD-40B9-9438-7A0A5F234A91")!,
            firstName: "Natalia",
            lastName: "Ivanova",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/75.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "D9DBFAF3-3056-4E69-BFA5-1A8A4D8A1387")!,
            firstName: "Aaliyah",
            lastName: "Brown",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/80.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "4DAAB2B7-33DB-46A5-B9D1-059D3B6B14BB")!,
            firstName: "Sophia",
            lastName: "Kim",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/85.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "7D9AC579-FF28-4D5F-BEB6-BB2C8ED14D0C")!,
            firstName: "Ines",
            lastName: "Rodriguez",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/90.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "0F244FFC-4F76-4ED4-88B3-8F924DA26B2B")!,
            firstName: "Naomi",
            lastName: "Scott",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/95.jpg"),
            matchedAt: ISO8601DateFormatter().date(from: "2024-10-07T11:26:00Z")!
        ),
        User(
            id: UUID(uuidString: "4EA5FC48-F4DA-4937-AC8D-4A139AA05D1D")!,
            firstName: "Hana",
            lastName: "Masuda",
            photoUrl: URL(string: "https://randomuser.me/api/portraits/women/99.jpg")
        )
    ]
}
