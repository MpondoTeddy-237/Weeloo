//
//  GarageOwnerLoginView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 26/04/2025.
//

import SwiftUI
import LocalAuthentication

struct GarageOwnerLoginView: View {
    @State private var userName = ""
    @State private var password = ""
    @State private var isAnimating = false
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var shakeOffset: CGFloat = 0
    @State private var showUserLogin = false
    @State private var showWelcomeView = false
    @State private var showForgotPasswordView = false
    @State private var buttonScale = 1.0
    @State private var showHomeView = false
    
    //When first time user logged in via email store this for future biometric login...
    @AppStorage("stored_GarageOwner") var garageOwner = ""
    @AppStorage("garageOwner_status") var logged = false
    
    // Email validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // User Login Button
                Button {
                    showUserLogin = true
                } label: {
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                        Text("LOG AS USER")
                            .font(.system(size: 10, weight: .semibold)) 
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.orange.opacity(0.8)]), 
                                     startPoint: .leading, 
                                     endPoint: .trailing)
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.indigo.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .scaleEffect(isAnimating ? 1 : 0.8)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(dampingFraction: 0.6).delay(0.1), value: isAnimating)
                .padding(.top, 20)
                
                Spacer(minLength: 0)
                
                // Animated Image
                Image("undraw_car-repair_wski") // Use a different image for garage owners
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200) // Reduced height
                    .padding(.horizontal, 35)
                    .padding(.vertical)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .opacity(isAnimating ? 1 : 0)
                    .rotationEffect(.degrees(isAnimating ? 0 : -10))
                    .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimating)
                
                // Title Section
                HStack {
                    VStack(alignment: .leading, spacing: 8) { // Reduced spacing
                        Text("Garage Owner Login")
                            .font(.system(size: 24, weight: .bold)) // Slightly smaller font
                            .foregroundColor(.indigo)
                            .offset(x: isAnimating ? 0 : -35)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(dampingFraction: 0.6).delay(0.3), value: isAnimating)
                        
                        Text("Access your garage dashboard")
                            .font(.system(size: 14)) 
                            .foregroundColor(Color.orange.opacity(0.5))
                            .offset(x: isAnimating ? 0 : -35)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(dampingFraction: 0.6).delay(0.4), value: isAnimating)
                    }
                    Spacer(minLength: 0)
                }
                .padding()
                .padding(.leading, 1)
                
                // Email Field
                HStack(spacing: 12) {
                    Image(systemName: "envelope")
                        .font(.system(size: 14))
                        .foregroundColor(.indigo)
                        .frame(width: 18)
                    
                    TextField("Email", text: $userName)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .font(.system(size: 14))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.indigo.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.indigo.opacity(0.5), lineWidth: 1)
                        )
                )
                .offset(x: shakeOffset)
                .offset(x: isAnimating ? 0 : 35)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(dampingFraction: 0.6).delay(0.5), value: isAnimating)
                .padding(.horizontal)
                
                // Password Field
                HStack(spacing: 12) { // Reduced spacing
                    Image(systemName: "lock")
                        .font(.system(size: 15)) // Smaller icon
                        .foregroundColor(.indigo)
                        .frame(width: 18) // Smaller frame
                    
                    if showPassword {
                        TextField("Password", text: $password)
                            .autocapitalization(.none)
                            .font(.system(size: 14)) // Smaller font
                    } else {
                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                            .font(.system(size: 14)) // Smaller font
                    }
                    
                    Button {
                        withAnimation {
                            showPassword.toggle()
                        }
                    } label: {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: 14)) // Smaller icon
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 12) // Reduced padding
                .padding(.horizontal, 15) // Reduced padding
                .background(
                    RoundedRectangle(cornerRadius: 20) // Smaller radius
                        .fill(Color.indigo.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Smaller radius
                                .stroke(Color.indigo.opacity(0.5), lineWidth: 1)
                        )
                )
                .offset(x: shakeOffset)
                .offset(x: isAnimating ? 0 : 35)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(dampingFraction: 0.6).delay(0.6), value: isAnimating)
                .padding(.horizontal)
                .padding(.top, 8) // Reduced spacing
                
                // Login Buttons Section
                HStack(spacing: 12) { // Reduced spacing
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            buttonScale = 0.9
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                buttonScale = 1
                                isLoading = true
                                // Simulate API call
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isLoading = false
                                    // Store email for future biometric login
                                    garageOwner = userName
                                    logged = true
                                    showHomeView = true
                                }
                            }
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {

                                Text("Login")
                                    .fontWeight(.bold)
                                    .font(.system(size: 14))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30) // Reduced height
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.orange.opacity(0.8)]),
                                         startPoint: .leading,
                                         endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12)) // Smaller radius
                        .shadow(color: Color.indigo.opacity(0.3), radius: 8, x: 0, y: 4) // Reduced shadow
                    }
                    .scaleEffect(buttonScale)
                    .padding(.horizontal, 30)
                    .disabled(userName.isEmpty || password.isEmpty)
                    .opacity(userName.isEmpty || password.isEmpty ? 0.6 : 1)
                    
                    if getBioMetricStatus() {
                        Button(action: authenticateUser) {
                            Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                                .font(.system(size: 25)) // Smaller icon
                                .foregroundColor(.white)
                                .padding(10) // Reduced padding
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.orange.opacity(0.8)]), 
                                                 startPoint: .leading, 
                                                 endPoint: .trailing)
                                )
                                .clipShape(Circle())
                        }
                        .scaleEffect(isAnimating ? 1 : 0.5)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.6).delay(0.7), value: isAnimating)
                    }
                }
                .padding(.top, 8)
                
                // Forgot Password Button
                Button {
                    showForgotPasswordView = true
                } label: {
                    Text("Forgot Password?")
                        .foregroundColor(.indigo)
                        .font(.system (size: 15, design: .rounded))
                        .fontWeight(.semibold)
                }
                .padding(.top, 10)
                .offset(y: isAnimating ? 0 : 20)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(dampingFraction: 0.6).delay(0.7), value: isAnimating)
                
                Spacer(minLength: 0)
                
                // Sign Up Section
                HStack(spacing: 5) {
                    Text("No account?")
                        .foregroundColor(Color.orange.opacity(0.5))
                        .font(.system(size: 12))
                    
                    Button {
                        // Handle signup
                    } label: {
                        NavigationLink(destination: GarageOwnerSignUpView()) {
                            Text("Owner Signup")
                                .fontWeight(.bold)
                                .foregroundColor(.indigo)
                                .font(.system(size: 13))
                        }
                    }
                }
                .padding(.vertical)
                .offset(y: isAnimating ? 0 : 20)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(dampingFraction: 0.6).delay(0.9), value: isAnimating)
                
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
                .offset(y: isAnimating ? 0 : 20)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(dampingFraction: 0.6).delay(1.0), value: isAnimating)
                .padding(.bottom, 20)
            }
            .background(Color(UIColor.systemBackground).ignoresSafeArea(.all, edges: .all))
            .onAppear {
                withAnimation {
                    isAnimating = true
                }
                // Check if user is already logged in with biometrics
                if logged {
                    authenticateUser()
                }
            }
            .navigationDestination(isPresented: $showWelcomeView) {
                WelcomeView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            .navigationDestination(isPresented: $showForgotPasswordView) {
                GarageOWnerForgotPasswordView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            .navigationDestination(isPresented: $showUserLogin) {
                LoginView()
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EmptyView()
                }
            }
        }
    }
    
    // Getting Biometric Type...
    func getBioMetricStatus() -> Bool {
        let scanner = LAContext()
        if isValidEmail(userName) && scanner.canEvaluatePolicy(.deviceOwnerAuthentication, error: .none) {
            return true
        }
        return false
    }
    
    // Authenticate User
    func authenticateUser() {
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, 
                             localizedReason: "To Unlock \(garageOwner)") { (status, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            // Setting logged status as true and storing the email
            withAnimation(.easeOut) {
                logged = true
                showHomeView = true
            }
        }
    }
}

#Preview {
    GarageOwnerLoginView()
}
