//
//  PodcastModel.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/30/22.
//

import Foundation
import SwiftyXMLParser

struct Podcast : Hashable {
    var id = UUID()

    var s3Prefix: String = ""
    
    // Required fields
    var title: String = ""
    var description: String = ""
    var image: String = ""
    var language: String = ""
    var category: String = ""
    var explicit: String = "False"
    var episodes: [Episode] = []

    // Recommended fields
    var author: String?
    var link: String?
    
    // Situational fields
    var type: String?
    var copyright: String?
    
    
    public static func fromXML(xml:XML.Accessor) -> Podcast? {
        var podcast = Podcast()
        
        // Required Fields
        guard let s3Prefix = xml["rss", "channel", "s3Prefix"].text else {
            print(1)
            return nil
        }
        podcast.s3Prefix = s3Prefix
        
        guard let title = xml["rss", "channel", "title"].text else {
            print(2)
            return nil
        }
        podcast.title = title
        
        guard let description = xml["rss", "channel", "description"].text else {
            print(3)
            return nil
        }
        podcast.description = description
        
        guard let image = xml["rss", "channel", "itunes:image"].attributes["href"]  else {
            print(4)
            return nil
        }
        podcast.image = image
        
        guard let language = xml["rss", "channel", "language"].text else {
            print(5)
            return nil
        }
        podcast.language = language
        
        guard let category = xml["rss", "channel", "itunes:category"].attributes["text"] else {
            print(6)
            return nil
        }
        podcast.category = category
        
        guard let explicit = xml["rss", "channel", "itunes:explicit"].text else {
            print(7)
            return nil
        }
        podcast.explicit = explicit
        
        // Optional Fields
        if let author = xml["rss", "channel", "itunes:author"].text {
            podcast.author = author
        }
        
        if let link = xml["rss", "channel", "link"].text {
            podcast.link = link
        }
        
        if let copyright = xml["rss", "channel", "copyright"].text {
            podcast.copyright = copyright
        }
        
        for episodeXML in xml["rss" ,"channel","item"] {
            if let episode = Episode.fromXML(xml: episodeXML) {
                podcast.episodes.append(episode)
            }
        }
        return podcast
    }
    
    
    func toXMLString() -> String {
        let rssNode = XMLElement(name: "rss")
        rssNode.addAttribute(XMLNode.attribute(withName: "version", stringValue: "2.0") as! XMLNode)
        rssNode.addAttribute(XMLNode.attribute(withName: "xmlns:content", stringValue: "http://purl.org/rss/1.0/modules/content/") as! XMLNode)
        rssNode.addAttribute(XMLNode.attribute(withName: "xmlns:itunes", stringValue: "http://www.itunes.com/dtds/podcast-1.0.dtd") as! XMLNode)
        
        let channelNode = XMLElement(name: "channel")
        rssNode.addChild(channelNode)
        
        let s3Prefix = XMLElement(name: "s3Prefix", stringValue: s3Prefix)
        channelNode.addChild(s3Prefix)
        
        let titleNode = XMLElement(name: "title", stringValue: title)
        channelNode.addChild(titleNode)
        
        let descriptionNode = XMLElement(name: "description", stringValue: description)
        channelNode.addChild(descriptionNode)
        
        let imageNode = XMLElement(name: "itunes:image")
        imageNode.addAttribute(XMLNode.attribute(withName: "href", stringValue: image) as! XMLNode)
        channelNode.addChild(imageNode)
        
        let languageNode = XMLElement(name: "language", stringValue: language)
        channelNode.addChild(languageNode)
        
        let categoryNode = XMLElement(name: "itunes:category")
        categoryNode.addAttribute(XMLNode.attribute(withName: "text", stringValue: category) as! XMLNode)
        channelNode.addChild(categoryNode)
        
        let explicitNode = XMLElement(name: "itunes:explicit", stringValue: explicit)
        channelNode.addChild(explicitNode)
        
        
        let authorNode = XMLElement(name: "itunes:author", stringValue: author)
        channelNode.addChild(authorNode)
        
        let linkNode = XMLElement(name: "link", stringValue: link)
        channelNode.addChild(linkNode)
        
        for episode in episodes {
            channelNode.addChild(episode.toXMLNode())
        }
        
        
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + rssNode.xmlString
    }
    
    mutating func addEpisode(episode: Episode) {
        episodes.insert(episode, at: 0)
    }
}

func getMockPodcast1() -> Podcast {
    // Mock Podcast
    var podcast = Podcast()
    podcast.title = "小lin说"
    podcast.image = "https://media.panjinbo.com/podcast/lintalk/lintalk.jpg"
    return podcast
}



func getMockPodcast2() -> Podcast {
    // Mock Podcast
    var podcast = Podcast()
    podcast.title = "今晚80后脱口秀"
    podcast.image = "https://media.panjinbo.com/podcast/80-talkshow/80-talkshow.png"
    return podcast
}

