//
//  ContentView.swift
//  Walutator
//
//  Created by Tomasz Korab on 15/09/2021.
//

import SwiftUI
import CurrencyPreview

struct ContentView: View {
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    CurrencyPreview(values: [1.11, 1.21, 0.70, 1.2, 0.96, 1.5, 1.45, 1.2, 1.21, ])
                        .frame(width: proxy.size.width, height: proxy.size.height * 0.3)
                    Spacer()
                }
            }
            .navigationTitle("USD")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
