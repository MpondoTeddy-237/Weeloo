//
//  Tab.swift
//  Weeloo
//
//  Created by TEDDY 237 on 26/04/2025.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case home = "house"
    case profile = "person.fill"
    case map = "location.fill"
    case settings = "gearshape"
    
    var title: String {
        switch self {
        case .home: return "Weeloo Home"
        case .profile: return "User Profile"
        case .map: return "Localise Garage"
        case .settings: return "Weeloo Settings"
        }
    }
}

//struct Tab<Content: View>: View {
  //  let content: Content
    //let value: TabModel
    
    //init(value: TabModel, @ViewBuilder content: @escaping () -> Content) {
      //  self.value = value
        //self.content = content()
    //}
    
    //var body: some View {
      //  content
        //    .tag(value)
    //}
//}

