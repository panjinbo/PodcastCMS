//
//  ContentView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/28/22.
//

import SwiftUI
import CoreData
import Alamofire
import SwiftyXMLParser



enum DetailViewContent {
    case empty
    case addPodcast
    case createEpisode
}


struct ContentView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch needed core data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PodcastMetadata.rss, ascending: true)],
        animation: .default)
    private var podcastMetadatas: FetchedResults<PodcastMetadata>
    
    
    
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var detailViewContent:DetailViewContent = DetailViewContent.empty
    
    @State private var selectedPodcast: Podcast?
    @State private var selectedEpisode: Episode?
    @State private var podcasts: [Podcast] = []
    
    // Modal window
    @State private var modalText: String = ""
    @State private var modalShow: Bool = false
    
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(podcasts ,id: \.self, selection: $selectedPodcast) { podcast in
                PodcastCardView(podcast: podcast)
            }
            .navigationTitle("Podcasts")
            .frame(minWidth: 300)
            .toolbar {
                ToolbarItem(placement: .primaryAction){
                    Button() {
                        selectedEpisode = nil
                        detailViewContent = .addPodcast
                    }
                label: {
                    Label("Add A Podcast", systemImage: "plus")
                }
                }
                
                ToolbarItem(placement: .secondaryAction){
                    Button() {
                        selectedEpisode = nil
                        detailViewContent = .createEpisode
                    }
                label: {
                    Label("Create An Episode", systemImage: "plus.square.fill.on.square.fill")
                }
                }
            }
        } content: {
            if let podcast = selectedPodcast {
                VStack{
                    List(podcast.episodes, id: \.self, selection: $selectedEpisode) { episode in
                        EpisodeCardView(episode: episode)
                    }
                }
            } else {
                Text("Please Select One Podcast.")
            }
        } detail: {
            if let selectedEpisode = selectedEpisode {
                EpisodeDetailView(episode: selectedEpisode)
            } else {
                switch detailViewContent {
                case .empty:
                    EmptyView()
                case .createEpisode:
                    if selectedPodcast == nil {
                        Text("Please select a Podcast to add Episode")
                    } else {
                        CreateEpisodeView(podcast: $selectedPodcast)
                    }
                case .addPodcast:
                    AddPodcastView(podcasts: $podcasts).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                }
            }
        }.onAppear{
            fetch()
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
    
    
    func fetch() {
        for podcastMetadata in podcastMetadatas {
            let rss = podcastMetadata.rss
            var req = URLRequest(url: URL(string: rss!)!)
            req.httpMethod = "GET"
            req.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            
            
            AF.request(req).responseData { response in
                let data = response.data!
                let xml = XML.parse(data)
                if let podcast = Podcast.fromXML(xml: xml) {
                    podcasts.append(podcast)
                } else {
                    print("wrong")
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
