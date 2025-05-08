//
//  CustomBar.swift
//  Weeloo
//
//  Created by TEDDY 237 on 26/04/2025.
//

import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }

        Publishers.Merge(willShow, willHide)
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
    }
}

struct CustomTabBar: View {
    var activeForeground: Color = .white
    var activeBackground: Color = .indigo
    @Binding var activeTab: TabModel
    /// For Matched Geometry Effect
    @Namespace private var animation
    @StateObject private var keyboardResponder = KeyboardResponder()
    @State private var showProfile = false
    
    var body: some View {
        let status = activeTab == .home || activeTab == .profile
        
        GeometryReader { geo in
            let safeArea = geo.safeAreaInsets.bottom

            HStack(spacing: status ? 12 : 0) {
                // Tab buttons
            HStack(spacing: 0) {
                ForEach(TabModel.allCases, id: \.rawValue) { tab in
                    Button {
                        withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                            activeTab = tab
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: tab.rawValue)
                                .font(.title3)
                                .frame(width: 30, height: 30)
                            if activeTab == tab {
                                Text(tab.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundColor(activeTab == tab ? activeForeground : .gray)
                        .padding(.vertical, 2)
                        .padding(.leading, 10)
                        .padding(.trailing, 15)
                        .contentShape(Rectangle())
                        .background {
                            if activeTab == tab {
                                Capsule()
                                    .fill(activeBackground)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 5)
            .frame(height: 45)
            .background {
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.06), radius: 5, x: -5, y: -5)
            }
            .zIndex(10)
                .layoutPriority(1)
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
            .padding(.bottom, safeArea > 0 ? safeArea : 10)
            .background(
                Color.white
                    .ignoresSafeArea(edges: .bottom)
            )
            .opacity(keyboardResponder.isKeyboardVisible ? 0 : 1)
            .animation(.easeInOut(duration: 0.25), value: keyboardResponder.isKeyboardVisible)
            }
        .frame(height: 60)
        .sheet(isPresented: $showProfile) {
            UserPostView()
        }
    }
}

#Preview {
    HomePageView()
}
