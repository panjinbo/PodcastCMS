//
//  CreatePodcastView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/29/22.
//

import SwiftUI

struct CreatePodcastView: View {
    // Apple Podcast Guide
    // https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    
    @State private var s3Prefix: String = ""
    
    // Required fields
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var image: String = ""
    @State private var language: String = ""
    @State private var category: String = ""
    @State private var explicit: String = "False"

    // Recommended fields
    @State private var author: String = ""
    @State private var link: String = ""
    @State private var ownerName: String = ""
    @State private var ownerEmail: String = ""
    
    // Situational fields
    @State private var type: String = ""
    @State private var copyright: String = ""

    
    var body: some View {
        LazyVStack() {
            Label("Add A New Podcast",systemImage: "music.mic").padding()
            
            HStack {
                Text("Title").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                TextField(text: $title, prompt: Text("Required")) {
                }.disableAutocorrection(true).textFieldStyle(.plain)
            }
            
            Divider()

            HStack {
                Text("Description").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                TextField(text: $description, prompt: Text("Required")) {
                }.disableAutocorrection(true).textFieldStyle(.plain)
            }
    
            Divider()

            HStack {
                Text("Language").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                TextField(text: $language, prompt: Text("Required")) {
                }.disableAutocorrection(true).textFieldStyle(.plain)
            }
            
            HStack {
                Text("Category").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                TextField(text: $category, prompt: Text("Required")) {
                }.disableAutocorrection(true).textFieldStyle(.plain)
            }
            
            Divider()
            
            HStack {
                Text("Explicit").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                Picker("", selection: $explicit) {
                    Text("False").tag("False")
                    Text("True").tag("True")
                }
            }
            Divider()
        }
    }
}

struct CreatePodcastView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePodcastView()
    }
}
