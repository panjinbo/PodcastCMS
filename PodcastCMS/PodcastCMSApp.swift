//
//  PodcastCMSApp.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/28/22.
//

import SwiftUI

@main
struct PodcastCMSApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                               PersistenceController.preview.container.viewContext)
        }
        
        
        Settings {
            SettingsView()
        }
        
    }
}
