//
//  Hero.swift
//  HeroRandomizerLab
//
//  Created by Тулепберген Анель  on 05.03.2025.
//

import Foundation

struct Hero: Codable, Identifiable {
    let id: Int
    let name: String
    let images: HeroImages
    let biography: Biography
    let powerstats: Powerstats
}

struct HeroImages: Codable {
    let lg: String
}

struct Biography: Codable {
    let fullName: String
    let placeOfBirth: String
}

struct Powerstats: Codable {
    let intelligence: Int?
    let strength: Int?
    let speed: Int?
    let durability: Int?
    let power: Int?
    let combat: Int?
}
