//
//  WelcomeView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 23/04/2025.
//

import SwiftUI

enum ViewStack{
    case login
    case registration
}


struct WelcomeView: View {
    @State private var presentNextView = false
    @State private var nextView: ViewStack = .login
    @State private var isAnimating = false
        
    var body: some View {
        NavigationStack{
            VStack {
                Image("diagnostique")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .padding(.top,50)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimating)
                    .padding(.bottom, 10)
                                
                Text("Personalised garage assistant")
                    .font(.system(size:35, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.indigo)
                    .padding(.bottom, 10)
                    .offset(y: isAnimating ? 0 : 50)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.3), value: isAnimating)
                
                Text("Create an account according to your needs. User or Garage owner, Enjoy using Weeloo !")
                    .font(.system(size:15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .offset(y: isAnimating ? 0 : 50)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.4), value: isAnimating)
                
                Spacer()
                
                HStack (spacing: 12) {
                    Button {
                        nextView = .login
                        presentNextView.toggle()
                    } label: {
                        Text("Login")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 150, height: 40)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.orange.opacity(0.8)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(12)
                    .padding(.bottom, 30)
                    .scaleEffect(isAnimating ? 1 : 0.8)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.5), value: isAnimating)
                    
                    Button {
                        nextView = .registration
                        presentNextView.toggle()
                    } label: {
                        Text("Register")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .frame(width: 150, height: 40)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.bottom, 30)
                    .scaleEffect(isAnimating ? 1 : 0.8)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.6), value: isAnimating)
                }
            }
            .padding()
            .navigationDestination(isPresented: $presentNextView) {
                switch nextView {
                case .login:
                    LoginView()
                case .registration:
                    SignUpView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EmptyView()
                }
            }
            .onAppear {
                withAnimation {
                    isAnimating = true
                }
            }
        }
    }
}
    
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
            WelcomeView()
    }
}


#Preview {
    WelcomeView()
}
