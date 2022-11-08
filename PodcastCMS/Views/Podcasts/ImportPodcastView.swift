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
    @Binding var podcasts: [Podcast]

    @State private var podcastURL: String = ""
    
    // Modal window
    @State private var modalText: String = ""
    @State private var modalShow: Bool = false

    
    var body: some View {
        VStack() {
            Label("Import A New Podcast",systemImage: "music.mic").padding()
            HStack {
                Text("Podcast URL").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                TextField(text: $podcastURL, prompt: Text("Required")) {
                }.disableAutocorrection(true).textFieldStyle(.plain)
            }
            Divider()
            Button (action: {
                importPodcast()
            }) {
                Text("Import")
            }
            
            .sheet(isPresented: $modalShow) {
                VStack {
                    TextField(text: $modalText){
                    }.foregroundColor(.black)
                        .disableAutocorrection(true)
                        .textFieldStyle(.plain)
                        .disabled(true)
                        .padding()
                    
                    Button (action: {
                        modalShow = false
                    }) {
                        Text("Close")
                    }.padding()
                }
            }
        }
    }
    
    private func importPodcast() {
        var req = URLRequest(url: URL(string: podcastURL)!)
        req.httpMethod = "GET"
        req.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        
        AF.request(req).responseData { response in
            let data = response.data!
            let xml = XML.parse(data)
            if let podcast = Podcast.fromXML(xml: xml) {
                let podcastMetadata = PodcastMetadata(context: viewContext)
                podcastMetadata.rss = podcastURL
                podcastMetadata.lastModifiedDate = Date()
                do {
                    try viewContext.save()
                } catch {
                    modalShow = true
                    modalText = "Given URL RSS is not valid"
                }
                podcasts.append(podcast)
            } else {
                modalShow = true
                modalText = "Given URL RSS is not valid"
            }
            modalShow = true
            modalText = "Successfully Imported"
        }
        
    }
    
    
}
