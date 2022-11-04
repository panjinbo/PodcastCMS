//
//  ImportPodcastView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/29/22.
//

import SwiftUI


import Alamofire
import SwiftyXMLParser

struct ImportPodcastView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var podcastURL: String = ""
    @State private var show: String = "abc"

    
    var body: some View {
        VStack() {
            Label("Import A New Podcast",systemImage: "music.mic").padding()
            HStack {
                Text("Podcast URL").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                TextField(text: $podcastURL, prompt: Text("Required")) {
                }.disableAutocorrection(true).textFieldStyle(.plain)
            }
            Divider()
        }
    }
    
    
}

struct ImportPodcastView_Previews: PreviewProvider {
    static var previews: some View {
        ImportPodcastView()
    }
}
