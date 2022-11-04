//
//  SettingsView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/28/22.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            

            PrivacySettingsView()
                .tabItem {
                    Label("Privacy", systemImage: "hand.raised")
                }
        }
        .frame(width: 600, height: 500)
    }
}



struct PrivacySettingsView: View {
   var body: some View {
       Text("Privacy Settings")
           .font(.title)
   }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

