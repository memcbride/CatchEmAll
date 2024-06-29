//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by Mark McBride on 6/28/24.
//

import SwiftUI

struct CreaturesListView: View {
    var creatures = ["Pikachu","Squirtle","Charzard","Snorlax"
    ]
    var body: some View {
        NavigationStack {
            List(creatures, id: \.self) { creature in
                Text(creature)
                    .font(.title2)
            }
            .listStyle(.plain)
            .navigationTitle("Pokemon")
        }

    }
}

#Preview {
    CreaturesListView()
}
