//
//  ContentView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 22/04/2025.
//

import SwiftUI

enum ContentPage: Int, CaseIterable {
    case AiPowered
    case locationTracking
    case UserOrClient
    
    var title: String {
        switch self {
        case .AiPowered:
            return "Ai-Assisted"
        case .locationTracking:
            return "Localise any Garage on Map"
        case .UserOrClient:
            return "User ? or Garage Owner"
        }
    }
    var description: String {
        switch self {
        case .AiPowered:
            return "Knowing our car and taking care of it has never been this easy, all at your fingertips 😊!. With the incredible power of Gemini Ai, Get clear and detailed answers to all your car problems"
        case .locationTracking:
            return "Localise any Garage around your location on Map , See thier Ratings and get in contact with a Garage owner !"
        case .UserOrClient:
            return "User, Enjoy Powerful Ai assistant to answer all your problems. Garage Owner ? Create a profile, Give the location to your garage and fill in your specialisations to help users know more about your services. Get Started NOW !"
        }
    }
}

struct ContentView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var deliveryOffset = false
    @State private var trackingProgress: CGFloat = 0.0
    @State private var showWelcomeView = false
    @State private var buttonScale: CGFloat = 1
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    TabView(selection: $currentPage) {
                        ForEach(ContentPage.allCases, id: \.rawValue) { page in
                            getPageView(for: page)
                                .tag(page.rawValue)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                    
                    // page indicator
                    HStack(spacing: 12) {
                        ForEach(0..<ContentPage.allCases.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.indigo : Color.gray.opacity(0.5))
                                .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    //Button
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            buttonScale = 0.9
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                buttonScale = 1
                                if currentPage < ContentPage.allCases.count - 1 {
                                    currentPage += 1
                                    isAnimating = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isAnimating = true
                                    }
                                } else {
                                    showWelcomeView = true
                                }
                            }
                        }
                    } label: {
                        Text(currentPage < ContentPage.allCases.count - 1 ? "Next" : "Get Started")
                            .font(.system(size:14, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.orange.opacity(0.8)]), 
                                             startPoint: .leading, 
                                             endPoint: .trailing)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.indigo.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .scaleEffect(buttonScale)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
                .navigationDestination(isPresented: $showWelcomeView) {
                    WelcomeView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            isAnimating = true
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private var carImageGroup: some View {
        ZStack {
            Image("assistant-ia 1")
                .resizable()
                .scaledToFit()
                .frame(height: 280)
                .offset(y: isAnimating ? 0 : 20)
                .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimating)
                .zIndex(1)
        }
    }
    
    private var locationAnimation: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                .frame(width: 250, height: 250)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 2.0).repeatForever(), value: isAnimating)
            
            Image("voiture-taxi")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .offset(y: deliveryOffset ? -20 : 0)
                .rotationEffect(.degrees(deliveryOffset ? 5 : -5))
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(dampingFraction: 0.7).delay(0.2), value: isAnimating)
            
            ForEach(0..<8) { index in
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .offset(
                        x: 120 * cos(Double(index) * .pi / 4),
                        y: 120 * sin(Double(index) * .pi / 4)
                    )
                    .scaleEffect(isAnimating ? 1 : 0)
                    .opacity(isAnimating ? 0.7 : 0)
                    .animation(.easeInOut(duration: 2.0)
                        .repeatForever()
                        .delay(Double(index) * 0.15),
                               value: isAnimating
                    )
            }
        }
    }
    
    private var UserOrClientAnimation: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                .frame(width: 250, height: 250)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 2.0).repeatForever(), value: isAnimating)
            
            Image("services-de-voiture")
                .resizable()
                .scaledToFit()
                .frame(height: 240)
                .opacity(isAnimating ? 1 : 0)
                .scaleEffect(isAnimating ? 1 : 0.8)
                .rotation3DEffect(.degrees(isAnimating ? 360 : 1), axis: (x: 0, y: 1, z: 0))
                .animation(.spring(dampingFraction: 0.7).delay(0.2), value: isAnimating)
            
            ForEach(0..<4) { index in
                Image(systemName: "location.fill")
                    .foregroundStyle(Color.blue)
                    .offset(x: 100 * cos(Double(index) * .pi / 2), y: 100 * cos(Double(index) * .pi / 2))
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(Double(index) * 0.15), value: isAnimating)
            }
        }
    }
    
    @ViewBuilder
    private func getPageView(for page: ContentPage) -> some View {
        VStack(spacing: 30) {
            //Image input code
            ZStack {
                switch page {
                case .AiPowered:
                    carImageGroup
                case .locationTracking:
                    locationAnimation
                case .UserOrClient:
                    UserOrClientAnimation
                }
            }
            
            //Text content
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
                
                Text(page.description)
                    .font(.system(.footnote, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
            }
        }
        .padding(.top, 50)
    }
}

#Preview {
    ContentView()
}
