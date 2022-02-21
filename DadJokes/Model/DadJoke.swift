//
//  DadJoke.swift
//  DadJokes
//
//  Created by Russell Gordon on 2022-02-21.
//

import Foundation

struct DadJoke: Decodable, Hashable {
    
    let id: String
    let joke: String
    let status: Int
    
}

// For use with a SwiftUI preview
let testJoke = DadJoke(id: "eNuHJBQCdFd",
                       joke: "How do you organize a space party? You planet.",
                       status: 200)

