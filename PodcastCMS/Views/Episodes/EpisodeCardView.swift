//
//  EpisodeCardView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 11/1/22.
//

import SwiftUI

struct EpisodeCardView: View {
    let episode:Episode
    
    var body: some View {
        VStack {
            Text(episode.title).fontWeight(.bold).padding()
            Text(episode.description ?? "").padding()
            Divider()
        }
    }
}

struct EpisodeCardView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeCardView(episode: getMockEpisode1())
    }
}
