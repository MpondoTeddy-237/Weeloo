//
//  GarageOWnerForgotPasswordView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 26/04/2025.
//

import SwiftUI

struct GarageOWnerForgotPasswordView: View {
    @State private var accountName = ""
    @State private var phoneNumber = ""
    @State private var isAnimating = false
    @State private var isLoading = false
    @State private var showSuccessMessage = false
    @State private var showGarageOwnerLogin = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.indigo)
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(dampingFraction: 0.6).delay(0.1), value: isAnimating)
                        
                        Text("Forgot your password?")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.indigo)
                            .offset(y: isAnimating ? 0 : 20)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimating)
                        
                        Text("Help us recover your garage account")
                            .font(.system(size: 13))
                            .foregroundColor(Color.orange.opacity(0.8))
                            .offset(y: isAnimating ? 0 : 20)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(dampingFraction: 0.6).delay(0.3), value: isAnimating)
                    }
                    .padding(.top, 20)
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        // Account Name Field
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.indigo)
                                .frame(width: 15)
                            
                            TextField("Enter your Garage Account Name", text: $accountName)
                                .autocapitalization(.none)
                                .font(.system (size: 13, design: .rounded))

                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.indigo.opacity(0.12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.indigo.opacity(0.5), lineWidth: 1)
                                )
                        )
                        .offset(x: isAnimating ? 0 : 30)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.4), value: isAnimating)
                        
                        // Phone Number Field
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.indigo)
                                .frame(width: 15)
                            
                            TextField("Enter your Phone Number", text: $phoneNumber)
                                .keyboardType(.phonePad)
                                .font(.system (size: 13, design: .rounded))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.indigo.opacity(0.12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.indigo.opacity(0.5), lineWidth: 1)
                                )
                        )
                        .offset(x: isAnimating ? 0 : 30)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.5), value: isAnimating)
                    }
                    .padding(.horizontal, 30)
                    
                    // Submit Button
                    Button {
                        withAnimation {
                            isLoading = true
                            // Simulate API call
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isLoading = false
                                showSuccessMessage = true
                            }
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Recover Account")
                                    .fontWeight(.bold)
                                    .font(.system (size: 15, design: .rounded))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.orange.opacity(0.8)]),
                                         startPoint: .leading,
                                         endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: Color.indigo.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 30)
                    .offset(y: isAnimating ? 0 : 20)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.6), value: isAnimating)
                    .disabled(accountName.isEmpty || phoneNumber.isEmpty)
                    .opacity(accountName.isEmpty || phoneNumber.isEmpty ? 0.6 : 1)
                    
                    if showSuccessMessage {
                        Text("We've sent a recovery link to your phone number")
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green.opacity(0.1))
                            )
                            .padding(.horizontal, 30)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    // Remember Password Button
                    HStack(spacing: 5) {
                        Text("Remember password?")
                            .foregroundColor(Color.orange.opacity(0.5))
                            .font(.system (size: 13, design: .rounded))
                        
                        Button {
                            showGarageOwnerLogin = true
                        } label: {
                            Text("Log as Owner")
                                .fontWeight(.bold)
                                .foregroundColor(.indigo)
                                .font(.system (size: 15, design: .rounded))
                        }
                    }
                    .padding(.vertical)
                    .offset(y: isAnimating ? 0 : 20)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.7), value: isAnimating)
                }
                .padding(.vertical)
            }
            .navigationDestination(isPresented: $showGarageOwnerLogin) {
                GarageOwnerLoginView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
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

#Preview {
    GarageOWnerForgotPasswordView()
}
