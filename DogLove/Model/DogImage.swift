//
//  DogImage.swift
//  DogLove
//
//  Created by Agnidhra Gangopadhyay on 2/28/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation

struct DogImage: Codable {
    let status: String
    let message: String
}

struct AllBreeds: Codable {
    let message: [String: [String]]
    let status: String
}


