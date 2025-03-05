//
//  HeroService.swift
//  HeroRandomizerLab
//
//  Created by Тулепберген Анель on 05.03.2025.
//

import Foundation

class HeroViewModel {
    private let apiURL = "https://akabab.github.io/superhero-api/api/all.json"
    
    func fetchRandomHero(completion: @escaping (Hero?) -> Void) {
        guard let url = URL(string: apiURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let heroes = try JSONDecoder().decode([Hero].self, from: data)
                    let randomHero = heroes.randomElement()
                    DispatchQueue.main.async {
                        completion(randomHero)
                    }
                } catch {
                    print("Ошибка парсинга JSON: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } else {
                print("Ошибка загрузки: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}

