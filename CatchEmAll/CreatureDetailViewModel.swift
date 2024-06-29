//
//  CreatureDetailViewModel.swift
//  CatchEmAll
//
//  Created by Mark McBride on 6/29/24.
//

import Foundation

@MainActor
class CreatureDetailViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var height: Double
        var weight: Double
        var sprites: Sprite
    }
    
    struct Sprite: Codable {
        var front_default: String?
        var other: Other
    }
    
    struct Other: Codable {
        var officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct OfficialArtwork: Codable {
        var front_default: String
    }
    
    var urlString = ""
    @Published var height = 0.0
    @Published var weight = 0.0
    @Published var imageURL = ""
        
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        // convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡  ERROR: Cound not create a URL from \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decond JSON data into our own data structures
            guard let returned = try?JSONDecoder().decode(Returned.self, from: data) else {
                print("😡  JSON ERROR: Cound not decode returned JSON data")
                return
            }
            self.height = returned.height
            self.weight = returned.weight
            self.imageURL = returned.sprites.other.officialArtwork.front_default
        } catch {
            print("😡  ERROR: Cound not get user URL at \(urlString) to get data and response")
        }
    }
}
