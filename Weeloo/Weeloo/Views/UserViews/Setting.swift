//
//  Setting.swift
//  Weeloo
//
//  Created by TEDDY 237 on 27/04/2025.
//

import SwiftUI

struct Setting: View {
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
                    NavigationLink(destination: Text("Profile Settings")) {
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
                .listRowBackground(Color.white)
                
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
                    .tint(.orange)
                    
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
                        .tint(.orange)
                        Toggle(isOn: $pushNotifications) {
                            Label {
                                Text("Push Notifications")
                                    .foregroundColor(.gray)
                            } icon: {
                                Image(systemName: "iphone")
                                .foregroundColor(.indigo)
                            }
                        }
                        .tint(.orange)
                    }
                }
                .listRowBackground(Color.white)
                
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
                .listRowBackground(Color.white)
                
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
                .listRowBackground(Color.white)
                
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
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
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
    Setting()
}
