//
//  CreateEpisodeView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/30/22.
//
import AVKit
import SwiftUI


struct CreateEpisodeView: View {
    // Have nil check when create this View
    // To have optional to keep the same optional binding type
    @Binding var podcast: Podcast?
    
    // Apple Podcast Guide
    // https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    
    // Required fields
    @State private var title: String = ""
    @State private var localFilePath: String = ""
    @State private var url: String = ""
    @State private var length: String = ""
    
    
    
    // Recommended fields
    @State private var pubDate: String = ""
    @State private var description: String = ""
    @State private var duration: String = ""
    @State private var link: String = ""
    
    // Situational fields
    @State private var episode: String = ""
    @State private var season: String = ""
    
    // Modal window
    @State private var modalText: String = ""
    @State private var modalShow: Bool = false
    
    
    
    var body: some View {
        VStack() {
            Label("Add A New Episode",systemImage: "music.mic.circle").padding()
            
            Group {
                HStack {
                    Text("Title").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                    TextField(text: $title, prompt: Text("Required")) {
                    }.disableAutocorrection(true).textFieldStyle(.plain)
                }
                
                Divider()
                
                HStack {
                    Text("Description").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                    TextField(text: $description, prompt: Text("Optional"),  axis: .vertical) {
                    }.disableAutocorrection(true).textFieldStyle(.plain).lineLimit(2)
                    
                }
                
                Divider()
                
                
                HStack {
                    Text("Local File path").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                    TextField(text: $localFilePath, prompt: Text("Optional")) {
                    }.disableAutocorrection(true).textFieldStyle(.plain)
                }
                Divider()
                
                HStack {
                    Text("Local File Size is: ").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                    TextField(text: $length){
                    }.disableAutocorrection(true).textFieldStyle(.plain).disabled(true)
                    
                    Text("Local File Duration is: ").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                    TextField(text: $duration){
                    }.disableAutocorrection(true).textFieldStyle(.plain).disabled(true)
                }
                
                
                HStack {
                    Text("Publish Date").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                    TextField(text: $pubDate, prompt: Text("Optional")) {
                    }.disableAutocorrection(true).textFieldStyle(.plain)
                }
                
                Divider()
                
                HStack {
                    Text("Episode Link").padding(.leading, 2).frame(width: 120, alignment:.leading).padding()
                    TextField(text: $link, prompt: Text("Optional")) {
                    }.disableAutocorrection(true).textFieldStyle(.plain)
                }
            }
            
            HStack {
                Button (action: {
                    Task {
                        await createEpisode()
                    }
                }) {
                    Text("Create")
                }
                
                Button (action: {
                    reset()
                }) {
                    Text("Reset")
                }
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
            
        }.onChange(of: localFilePath, perform: {path in
            getFileSize(filePath: path)
            getAudioLength(filePath: path)
        })
    }
    
    // Get file bytes size
    private func getFileSize(filePath: String) {
        if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: filePath) {
            if let bytes = fileAttributes[.size] as? Int64 {
                length = String(bytes)
            }
        }
    }
    
    // Get audio length
    private func getAudioLength(filePath: String) {
        do {
            try duration = String(AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath)).duration)
        } catch {
            modalShow = true
            modalText = "Cannot get the MP3 file audio length"
        }}
    
    private func reset() {
        title = ""
        localFilePath = ""
        url = ""
        length = ""
        pubDate = ""
        description = ""
        duration = ""
        link = ""
        episode = ""
        season = ""
    }
    
    // Create the episode based on the data entered
    // It will first upload the audio file to S3
    // If upload succeeds, it will then update the xml rss and upload to S3
    private func createEpisode() async {
        guard let s3Client =  getDefaultS3Client() else {
            modalShow = true
            modalText = "Please set up S3 credentials"
            return
        }
        
        var newEpisode = Episode()
        
        newEpisode.id = UUID().uuidString
        newEpisode.title = title
        newEpisode.length = length
        let newEpisodeS3Key = podcast!.s3Prefix + "/audio/" + newEpisode.id + ".mp3"
        guard let cloudfrontURL = UserDefaults.standard.string(forKey: cloudfrontURLString) else {
            modalShow = true
            modalText = "Please set up Cloudfront URL"
            return
        }
        newEpisode.url = cloudfrontURL + "/" + newEpisodeS3Key
        newEpisode.description = description
        newEpisode.pubDate = pubDate
        newEpisode.link = link
        newEpisode.duration = duration
        
        guard let s3Bucket = UserDefaults.standard.string(forKey: s3BucketString) else {
            modalShow = true
            modalText = "Please set up S3 bucket"
            return
        }
        
        do {
            try await s3Client.uploadFile(bucket: s3Bucket, key: newEpisodeS3Key, file: localFilePath)}
        catch {
            modalShow = true
            modalText = "Failed to upload audio file to S3"
            return
        }
        
        podcast!.addEpisode(episode: newEpisode)
        let feedData = (podcast!.toXMLString().data(using: .utf8))!
        let feedKey = podcast!.s3Prefix + "/feed.xml"
        do {
            try await s3Client.createFile(bucket: s3Bucket, key: feedKey, withData: feedData)}
        catch {
            modalShow = true
            modalText = "Failed to upload updated feed XML to S3"
        }
        
        modalShow = true
        modalText = "Successfully Create The Episode"
        
    }
}
