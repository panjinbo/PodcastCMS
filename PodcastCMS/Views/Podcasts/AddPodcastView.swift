//
//  AddPodcastView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/28/22.
//

import SwiftUI

// creating items only as needed.
struct AddPodcastView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var podcasts: [Podcast]
    
    var body: some View {
        
        TabView {
            CreatePodcastView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).tabItem {
                Label("Create", systemImage: "gear")
            }
            ImportPodcastView(podcasts: $podcasts).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).tabItem {
                Label("Import", systemImage: "gear")
            }
        }
    }
}
