//
//  SettingView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 27/04/2025.
//

import SwiftUI

struct SettingView: View {
    @State private var isDarkMode = false
    @State private var notificationsEnabled = true
    @State private var emailNotifications = true
    @State private var pushNotifications = true
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            List {
                // Account Section
                Section(header: Text("Account").foregroundColor(.indigo)) {
                    NavigationLink(destination: UserProfile()) {
                        Label {
                            Text("Profile")
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "person.circle")
                            .foregroundColor(.indigo)
                        }
                    }
                    NavigationLink(destination: Text("Security Settings")) {
                        Label {
                            Text("Security")
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "lock.shield")
                            .foregroundColor(.indigo)
                        }
                    }
                    NavigationLink(destination: Text("Payment Methods")) {
                        Label {
                            Text("Payment Methods")
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "creditcard")
                            .foregroundColor(.indigo)
                        }
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                        .padding(.vertical, 4)
                )
                
                // Notifications Section
                Section(header: Text("Notifications").foregroundColor(.indigo)) {
                    Toggle(isOn: $notificationsEnabled) {
                        Label {
                            Text("Enable Notifications")
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "bell")
                            .foregroundColor(.indigo)
                        }
                    }
                    .tint(.indigo)
                    
                    if notificationsEnabled {
                        Toggle(isOn: $emailNotifications) {
                            Label {
                                Text("Email Notifications")
                                    .foregroundColor(.gray)
                            } icon: {
                                Image(systemName: "envelope")
                                .foregroundColor(.indigo)
                            }
                        }
                        .tint(.indigo)
                        
                        Toggle(isOn: $pushNotifications) {
                            Label {
                                Text("Push Notifications")
                                    .foregroundColor(.gray)
                            } icon: {
                                Image(systemName: "iphone")
                                .foregroundColor(.indigo)
                            }
                        }
                        .tint(.indigo)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                        .padding(.vertical, 4)
                )
                
                // Appearance Section
                Section(header: Text("Appearance").foregroundColor(.indigo)) {
                    NavigationLink(destination: LanguageSettingsView()) {
                        HStack {
                            Label {
                                Text("Language")
                                    .foregroundColor(.gray)
                            } icon: {
                                Image(systemName: "globe")
                                .foregroundColor(.indigo)
                            }
                            Spacer()
                            Text(selectedLanguage)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                        .padding(.vertical, 4)
                )
                
                // Support Section
                Section(header: Text("Support").foregroundColor(.indigo)) {
                    NavigationLink(destination: Text("Help Center")) {
                        Label {
                            Text("Help Center")
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "questionmark.circle")
                            .foregroundColor(.indigo)
                        }
                    }
                    NavigationLink(destination: Text("Contact Us")) {
                        Label {
                            Text("Contact Us")
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "envelope")
                            .foregroundColor(.indigo)
                        }
                    }
                    NavigationLink(destination: Text("About")) {
                        Label {
                            Text("About")
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "info.circle")
                            .foregroundColor(.indigo)
                        }
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                        .padding(.vertical, 4)
                )
                
                // Sign Out Button
                Section {
                    Button(action: {
                        // Handle sign out
                    }) {
                        HStack {
                            Spacer()
                            Label {
                            Text("Sign Out")
                                    .fontWeight(.medium)
                            } icon: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                            .foregroundColor(.red)
                            .padding(.vertical, 12)
                            Spacer()
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(InsetGroupedListStyle())
            .background(Color.gray.opacity(0.1))
            .tint(.indigo)
            .onAppear {
                withAnimation {
                    isAnimating = true
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
