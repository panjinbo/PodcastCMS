//
//  EpisodeDetailView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/30/22.
//

import AVKit
import SwiftUI

struct EpisodeDetailView: View {
    var episode:Episode

    var body: some View {
        VStack
        {
            HStack {
                Text("Title").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                Text(episode.title ).padding()
            }

            HStack {
                Text("Description").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                Text(episode.description ?? "").padding()
            }

            VideoPlayer(player: AVPlayer(url:  URL(string: episode.url )!))
                .frame(height: 100).padding()
        }
    }
}

struct EpisodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeDetailView(episode: getMockEpisode1())
    }
}
