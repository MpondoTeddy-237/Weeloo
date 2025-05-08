//
//  HomeView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 29/04/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showImage = false
    @State private var showTips = false
    @State private var showProblems = false
    @State private var showFooter = false
    @State private var navigateToAI = false
    @State private var navigateToGarage = false
    @State private var navigateToSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
            LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.15), Color.orange.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                if showImage {
                    Image(systemName: "car.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 80)
                        .foregroundColor(.indigo)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .shadow(color: .indigo.opacity(0.2), radius: 10, x: 0, y: 8)
                        .padding(.bottom, 10)
                }
                if showTitle {
                    Text("Welcome to Weeloo Garage")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.indigo)
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .scale))
                        .padding(.bottom, 4)
                }
                if showSubtitle {
                    Text("Your AI-powered car assistant")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .padding(.bottom, 24)
                }
                if showTips {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🚗 Car Tips")
                            .font(.headline)
                            .foregroundColor(.orange)
                        AnimatedTip(text: "Check your tire pressure monthly for better fuel efficiency.")
                        AnimatedTip(text: "Change your oil every 5,000-7,000 miles.")
                        AnimatedTip(text: "Keep your car clean to prevent rust and paint damage.")
                    }
                    .padding()
                    .background(BlurView(style: .systemMaterial))
                    .cornerRadius(18)
                    .shadow(color: .orange.opacity(0.08), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 24)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
                if showProblems {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("⚠️ Common Car Problems")
                            .font(.headline)
                            .foregroundColor(.red)
                        AnimatedTip(text: "Engine won't start: Check battery and starter.")
                        AnimatedTip(text: "Strange noises: Could be brakes, suspension, or engine.")
                        AnimatedTip(text: "Warning lights: Don't ignore them—get diagnostics soon.")
                    }
                    .padding()
                    .background(BlurView(style: .systemMaterial))
                    .cornerRadius(18)
                    .shadow(color: .red.opacity(0.08), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 24)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
                Spacer()
                if showFooter {
                    VStack(spacing: 8) {
                        Text("Get started by exploring our AI Assistant or locating a garage near you!")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        HStack(spacing: 16) {
                                Button(action: { navigateToAI = true }) {
                                Label("AI Assistant", systemImage: "brain")
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .background(Color.indigo.opacity(0.9))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                                Button(action: { navigateToGarage = true }) {
                                Label("Find Garage", systemImage: "location.fill")
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .background(Color.orange.opacity(0.9))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .transition(.opacity)
                    .padding(.bottom, 30)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.7)) { showImage = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeOut(duration: 0.7)) { showTitle = true }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    withAnimation(.easeOut(duration: 0.7)) { showSubtitle = true }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeOut(duration: 0.7)) { showTips = true }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.7)) { showProblems = true }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                    withAnimation(.easeOut(duration: 0.7)) { showFooter = true }
                }
            }
                // Settings Button
                Button(action: { navigateToSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.indigo)
                        .padding(12)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(color: .indigo.opacity(0.08), radius: 4, x: 0, y: 2)
                        .padding(.top, 16)
                        .padding(.trailing, 20)
                }
            }
            // Navigation Links
            .navigationDestination(isPresented: $navigateToAI) {
                Ai_interfaceView()
            }
            .navigationDestination(isPresented: $navigateToGarage) {
                ClientMapView()
            }
            .navigationDestination(isPresented: $navigateToSettings) {
                Setting()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct AnimatedTip: View {
    let text: String
    @State private var revealed = false
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(.primary)
            .opacity(revealed ? 1 : 0)
            .offset(y: revealed ? 0 : 10)
            .animation(.easeOut(duration: 0.7), value: revealed)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    revealed = true
                }
            }
    }
}

// BlurView for background effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct HideTabBar: UIViewRepresentable {
    var result: () -> ()
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let tabController = view.tabController {
                tabController.tabBar.isHidden = true
                result()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

extension UIView {
    var tabController: UITabBarController? {
        if let controller = sequence(first: self, next: {
            $0.next
        }).first(where: {$0 is UITabBarController}) as? UITabBarController {
            return controller
        }
        
        return nil
    }
}

#Preview {
    HomeView()
}
