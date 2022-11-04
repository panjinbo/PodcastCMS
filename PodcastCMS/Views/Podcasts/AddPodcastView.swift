//
//  AddPodcastView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/28/22.
//

import SwiftUI

// creating items only as needed.
struct AddPodcastView: View {
    
    
    var body: some View {
        
        TabView {
            CreatePodcastView().tabItem {
                Label("Create", systemImage: "gear")
            }
            ImportPodcastView().tabItem {
                Label("Import", systemImage: "gear")
            }
        }
    }
}

struct AddPodcastView_Previews: PreviewProvider {
    static var previews: some View {
        AddPodcastView()
    }
}
