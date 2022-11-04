//
//  Episode.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/30/22.
//

import Foundation
import SwiftyXMLParser

struct Episode: Identifiable, Hashable, Codable {
    var id = ""
    
    // Required fields
    var title: String = ""
    var length: String = ""
    var type: String = "audio/mpeg"
    var url: String = ""

    // Recommended fields
    var description: String?
    var pubDate: String?
    var link: String?
    var duration: String?
    
    public static func fromXML(xml:XML.Accessor) -> Episode? {
        var episode = Episode()

        // Required Fields
        
        guard let id = xml["id"].text else {
            return nil
        }
        episode.id = id
        
        guard let title = xml["title"].text else {
            return nil
        }
        episode.title = title
            
        guard let length = xml["enclosure"].attributes["length"] else {

            return nil
        }
        episode.length = length
        
        guard let type = xml["enclosure"].attributes["type"] else {

            return nil
        }
        episode.type = type
        
        guard let url = xml["enclosure"].attributes["url"] else {

            return nil
        }
        episode.url = url

        // Optional Fields
        if let description = xml["description"].text {
            episode.description = description
        }
        
        if let pubDate = xml["pubDate"].text {
            episode.pubDate = pubDate
        }
        
        if let duration = xml["itunes:duration"].text {
            episode.duration = duration
        }
        
        if let link = xml["link"].text {
            episode.link = link
        }
        
        
        return episode
    }
    
    public func toXMLNode() -> XMLElement {
        let episodeNode = XMLElement(name: "item")
        
        let idNode = XMLElement(name: "id", stringValue: id)
        episodeNode.addChild(idNode)

        let titleNode = XMLElement(name: "title", stringValue: title)
        episodeNode.addChild(titleNode)
        
        let enclosureNode = XMLElement(name: "enclosure")
        enclosureNode.addAttribute(XMLNode.attribute(withName: "length", stringValue: length) as! XMLNode)
        enclosureNode.addAttribute(XMLNode.attribute(withName: "type", stringValue: type) as! XMLNode)
        enclosureNode.addAttribute(XMLNode.attribute(withName: "url", stringValue: url) as! XMLNode)
        episodeNode.addChild(enclosureNode)
        
        
        let descriptionNode = XMLElement(name: "description", stringValue: description)
        episodeNode.addChild(descriptionNode)
        
        let pubDateNode = XMLElement(name: "pubDate", stringValue: pubDate)
        episodeNode.addChild(pubDateNode)

        let durationNode = XMLElement(name: "itunes:duration", stringValue: duration)
        episodeNode.addChild(durationNode)
        
        let linkNode = XMLElement(name: "link", stringValue: link)
        episodeNode.addChild(linkNode)

        return episodeNode
    }
}

func getMockEpisode1() -> Episode {
    // Mock Episode
    var episode = Episode()
    episode.title = "日本经济失落的三十年"
    episode.length = "60431698"
    episode.type = "audio/mpeg"
    episode.url = "https://media.panjinbo.com/podcast/lintalk/audio/4c1b197e-100a-41cd-bb1e-edb74456569a.mp3"
    episode.description = "今天咱们接着之前日本经济泡沫的破裂，聊一聊日本之后挨的一拳接着一拳，央行和政府跟通货紧缩的斗争到底都有哪些骚操作？ 这失落的三十年，他们到底经历了什么！"
    episode.pubDate = "Fri, 07 Oct 2022 04:48:51 CST"
    episode.duration = "1510"
    return episode
}
