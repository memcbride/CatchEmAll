//
//  CreaturesViewModel.swift
//  CatchEmAll
//
//  Created by Mark McBride on 6/28/24.
//

import Foundation

@MainActor
class CreaturesViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var count: Int
        var next: String?
        var results: [Creature]
    }
        
    @Published var urlString = "https://pokeapi.co/api/v2/pokemon"
    @Published var count = 0
    @Published var creaturesArray: [Creature] = []
    @Published var isLoading = false
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        isLoading = true
        
        // convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡  ERROR: Cound not create a URL from \(urlString)")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decond JSON data into our own data structures
            guard let returned = try?JSONDecoder().decode(Returned.self, from: data) else {
                print("😡  JSON ERROR: Cound not decode returned JSON data")
                isLoading = false
                return
            }
            self.count = returned.count
            self.urlString = returned.next ?? ""
            self.creaturesArray = self.creaturesArray + returned.results
            isLoading = false
        } catch {
            isLoading = false
            print("😡  ERROR: Cound not get user URL at \(urlString) to get data and response")
        }
    }
    
    func loadNextIfNeeded(creature: Creature) async {
        guard let lastCreature = creaturesArray.last else {
             return
        }
        if creature.id == lastCreature.id && urlString.hasPrefix("http") {
                Task {
                    await getData()
                }
            }
        }
    
    func loadAll() async {
        guard urlString.hasPrefix("http") else {return}
        
        await getData() // get next page of data
        await loadAll() // call loadAll again - will stop when all pages are retrieved
    }
}
