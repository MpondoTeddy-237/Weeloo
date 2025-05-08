//
//  LanguageSettingsView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 27/04/2025.
//

import SwiftUI

struct LanguageSettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("selectedLanguageCode") private var selectedLanguageCode = "en"
    @Environment(\.dismiss) private var dismiss
    @State private var isAnimating = false
    
    let languages = [
        ("English", "en", "🇬🇧"),
        ("Français", "fr", "🇫🇷"),
        ("Español", "es", "🇪🇸"),
        ("Deutsch", "de", "🇩🇪")
    ]
    
    var body: some View {
        List {
            ForEach(languages, id: \.1) { language in
                Button(action: {
                    selectedLanguage = language.0
                    selectedLanguageCode = language.1
                    // Trigger language change notification
                    NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
                }) {
                    HStack {
                        Text(language.2)
                            .font(.title2)
                        Text(language.0)
                            .foregroundColor(.indigo)
                        Spacer()
                        if selectedLanguage == language.0 {
                            Image(systemName: "checkmark")
                                .foregroundColor(.indigo)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                    .padding(.vertical, 4)
            )
            
            Section(header: Text("About Languages").foregroundColor(.indigo)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Language Selection")
                        .font(.headline)
                        .foregroundColor(.indigo)
                    Text("Changing the language will update the app's interface. Some content may remain in the original language.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                    .padding(.vertical, 4)
            )
        }
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.indigo)
            }
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
    }
}

#Preview {
    NavigationView {
        LanguageSettingsView()
    }
} 
