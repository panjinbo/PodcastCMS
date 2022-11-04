//
//  PodcastCardView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/30/22.
//

import SwiftUI

struct PodcastCardView: View {
    let podcast:Podcast
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: podcast.image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            // Since the AsyncImagePhase enum isn't frozen,
                            // we need to add this currently unused fallback
                            // to handle any new cases that might be added
                            // in the future:
                            EmptyView()
                        }
            }.frame(width:100, height: 100)
            Text(podcast.title).padding()
        }.frame(minWidth: 150)
       
    }
}

struct PodcastCardView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastCardView(podcast: getMockPodcast1())
    }
}
