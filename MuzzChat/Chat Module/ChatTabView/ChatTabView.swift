//
//  ChatTabView.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 08/10/2024.
//

import SwiftUI

struct ChatTabView: View {
    struct Tab {
        let view: AnyView
        let title: String
    }
    
    let preferredHeight: CGFloat = 40.0
    
    let tabs: [ChatTabView.Tab]
    @State private var selectedTab = 0
    
    init(tabs: [ChatTabView.Tab]) {
        self.tabs = tabs
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: preferredHeight)
                    .shadow(position: .bottom)
                
                HStack(spacing: 0) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        ChatTabButton(
                            title: tabs[index].title,
                            isSelected: selectedTab == index,
                            onTap: { selectedTab = index }
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: preferredHeight)
                    }
                }
                .background(Color.muzzLightBackground)
            }
            .zIndex(2)
            
            TabView(selection: $selectedTab) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    tabs[index].view
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: selectedTab)
            .zIndex(1)
        }
    }
}

struct ChatTabButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    let underlineHeight: CGFloat = 4.0
    
    var body: some View {
        Button(action: onTap) {
            VStack {
                Text(title)
                    .foregroundColor(isSelected ? .muzzPink : .gray)
                    .font(isSelected ? .body.bold() : .body)
                    .frame(maxHeight: .infinity)
                
                if isSelected {
                    Rectangle()
                        .frame(height: underlineHeight)
                        .foregroundColor(.muzzPink)
                } else {
                    Color.clear
                        .frame(height: underlineHeight)
                }
            }
        }
        .animation(.easeOut, value: isSelected)
    }
}
