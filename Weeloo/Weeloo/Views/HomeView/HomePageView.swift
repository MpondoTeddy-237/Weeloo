//
//  HomePageView.swift
//  Weeloo
//
//  Created by TEDDY 237 on 22/04/2025.
//

import SwiftUI

struct HomePageView: View {
    /// View Properties
    @State private var activeTab: TabModel = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                GarageOwnerHomeView()
                    .tag(TabModel.home)
                
                UserProfile()
                    .tag(TabModel.profile)
                
                LocalisationView()
                    .tag(TabModel.map)
                
                SettingView()
                    .tag(TabModel.settings)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden(true)
            
            CustomTabBar(activeTab: $activeTab)
        }
    }
}


#Preview {
    HomePageView()
}

