//
//  GarageOwnerSignUpView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 26/04/2025.
//

import SwiftUI

struct GarageOwnerSignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var location = ""
    @State private var isAnimating = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    @State private var showLoginView = false
    @State private var showHomeView = false
    @State private var showLocationPicker = false
    @State private var showSignUpView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    // Header
                    VStack(spacing: 10) {
                        Image("open-enrollment")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110)
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(dampingFraction: 0.6).delay(0.1), value: isAnimating)
                        
                        Text("Garage Owner Sign Up")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.indigo)
                            .offset(y: isAnimating ? 0 : 15)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimating)
                        
                        Text("Please fill in the form to continue")
                            .font(.system(size: 13))
                            .foregroundColor(Color.orange.opacity(0.8))
                            .offset(y: isAnimating ? 0 : 15)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(dampingFraction: 0.6).delay(0.3), value: isAnimating)
                    }
                    .padding(.top, 18)
                    
                    // Form Fields
                    VStack(spacing: 12) {
                        // Name Field
                        FormField(icon: "person.fill", 
                                 placeholder: "Full Name",
                                 text: $name,
                                 isSecure: false,
                                 delay: 0.4)
                            .font(.system(size: 14))
                        
                        // Email Field
                        FormField(icon: "envelope.fill",
                                 placeholder: "Email",
                                 text: $email,
                                 isSecure: false,
                                 delay: 0.5)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 14))
                        
                        // Password Field
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.indigo)
                                .font(.system(size: 14))
                                .frame(width: 18)
                            
                            if showPassword {
                                TextField("Password", text: $password)
                                    .font(.system(size: 14))
                            } else {
                                SecureField("Password", text: $password)
                                    .font(.system(size: 14))
                            }
                            
                            Button {
                                withAnimation {
                                    showPassword.toggle()
                                }
                            } label: {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 13))
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.indigo.opacity(0.12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.indigo.opacity(0.5), lineWidth: 1)
                                )
                        )
                        .offset(x: isAnimating ? 0 : 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.6), value: isAnimating)
                        
                        // Confirm Password Field
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.indigo)
                                .font(.system(size: 15))
                                .frame(width: 18)
                            
                            if showConfirmPassword {
                                TextField("Confirm Password", text: $confirmPassword)
                                    .font(.system(size: 14))
                            } else {
                                SecureField("Confirm Password", text: $confirmPassword)
                                    .font(.system(size: 14))
                            }
                            
                            Button {
                                withAnimation {
                                    showConfirmPassword.toggle()
                                }
                            } label: {
                                Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.indigo.opacity(0.12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.indigo.opacity(0.5), lineWidth: 1)
                                )
                        )
                        .offset(x: isAnimating ? 0 : 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.65), value: isAnimating)
                        
                        // Phone Number Field
                        FormField(icon: "phone.fill",
                                 placeholder: "Phone Number",
                                 text: $phoneNumber,
                                 isSecure: false,
                                 delay: 0.7)
                            .keyboardType(.phonePad)
                            .font(.system(size: 14))
                        
                        // Location Button (replaces text field)
                        Button {
                            showLocationPicker = true
                        } label: {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.indigo)
                                    .font(.system(size: 15))
                                    .frame(width: 18)
                                Text(location.isEmpty ? "Select Location" : location)
                                    .foregroundColor(location.isEmpty ? .gray : .indigo)
                                    .font(.system(size: 14, weight: location.isEmpty ? .regular : .semibold))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 13))
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.indigo.opacity(0.12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.indigo.opacity(0.5), lineWidth: 1)
                                    )
                            )
                        }
                        .offset(x: isAnimating ? 0 : 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.75), value: isAnimating)
                    }
                    .padding(.horizontal, 16)
                    
                    // Sign Up Button
                    Button {
                        withAnimation {
                            isLoading = true
                            // Handle signup process
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign Up")
                                    .font(.system(size: 15, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.orange.opacity(0.8)]),
                                         startPoint: .leading,
                                         endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.indigo.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(.horizontal, 25)
                    .offset(y: isAnimating ? 0 : 12)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.8), value: isAnimating)
                    .disabled(name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || phoneNumber.isEmpty || location.isEmpty)
                    .opacity(name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || phoneNumber.isEmpty || location.isEmpty ? 0.6 : 1)
                    
                    // Sign In As User Button
                    Button {
                        showSignUpView = true
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 14))
                            Text("SIGN UP AS USER")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.orange.opacity(0.8)]), 
                                         startPoint: .leading, 
                                         endPoint: .trailing)
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color.indigo.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .offset(y: isAnimating ? 0 : 12)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.9), value: isAnimating)
                    .padding(.top, 10)
                    
                    // Social Login Section
                    VStack(spacing: 20) {
                        Text("Or continue with")
                            .foregroundColor(Color.orange.opacity(0.5))
                            .font(.system(size: 14))
                        
                        HStack(spacing: 25) {
                            // Google Button
                            Button {
                                // Handle Google login
                            } label: {
                                Image("google-logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 25)
                                    .padding(12)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Facebook Button
                            Button {
                                // Handle Facebook login
                            } label: {
                                Image("facebook-logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 25)
                                    .padding(12)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Apple Button
                            Button {
                                // Handle Apple login
                            } label: {
                                Image("apple-logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 25)
                                    .padding(12)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .offset(y: isAnimating ? 0 : 12)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.95), value: isAnimating)
                    .padding(.top, 10)
                    
                    // Already have an account section
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 13))
                            .foregroundColor(Color.orange.opacity(0.5))
                        
                        Button {
                            showLoginView = true
                        } label: {
                            Text("Log in")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.indigo)
                        }
                    }
                    .padding(.vertical, 6)
                    .offset(y: isAnimating ? 0 : 12)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(1.0), value: isAnimating)
                }
            }
            .navigationDestination(isPresented: $showLoginView) {
                GarageOwnerLoginView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            .navigationDestination(isPresented: $showHomeView) {
                HomePageView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            .navigationDestination(isPresented: $showLocationPicker) {
                LocalisationView()
            }
            .navigationDestination(isPresented: $showSignUpView) {
                SignUpView()
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
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
    }
}

// Reuse the FormField from SignUpView

#Preview {
    GarageOwnerSignUpView()
}
