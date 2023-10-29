//
//  cardDataStruct.swift
//  likeOrDislike
//
//  Created by hanif hussain on 23/10/2023.
//

import Foundation

struct cardData: Codable {
    let url: Urls
}

struct Urls: Codable {
    let regular: String
    var regularUrl: URL {
        return URL(string: regular)!
    }
}
