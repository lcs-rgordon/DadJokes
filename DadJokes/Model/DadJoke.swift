//
//  DadJoke.swift
//  DadJokes
//
//  Created by Russell Gordon on 2022-02-21.
//

import Foundation

// Conforming to Codable is just a shortcut for
// conforming to two protocols:
//
// Encodable (saving an instance of the structure to JSON)
// - occurs when sending data to a web service
// - occurs when saving data to a local file on the device
// Decodable (populating an instance of the structure from JSON)
// - occurs when receiving data from a web service
// - occurs when loading data from a local file on the device
struct DadJoke: Codable, Hashable {
    
    let id: String
    let joke: String
    let status: Int
    
}

// For use with a SwiftUI preview
let testJoke = DadJoke(id: "eNuHJBQCdFd",
                       joke: "How do you organize a space party? You planet.",
                       status: 200)

