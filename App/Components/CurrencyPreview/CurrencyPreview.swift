//
//  SwiftUIView.swift
//  
//
//  Created by Tomasz Korab on 04/09/2021.
//

import SwiftUI

public struct CurrencyPreview: View {
    
    private let viewModel: CurrencyPreviewViewModel
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(values: [Double]) {
        self.viewModel = CurrencyPreviewViewModel(values: values)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: gradientColors()), startPoint: .top, endPoint: .bottom)
                        .clipShape(LineGraph(values: viewModel.values, closed: true))
                    LineGraph(values: viewModel.values, closed: false)
                        .stroke(Color.accentColor, lineWidth: 2)
                    Grid(xGranularity: viewModel.xGranularity, yGranularity: viewModel.yGranularity)
                }
                .scaleEffect(x: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/, y: -1, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
    private func gradientColors() -> [Color] {
        switch colorScheme {
        case .dark:
            return [Color.black.opacity(0.0), Color.accentColor]
        case .light:
            return [Color.white.opacity(0.0), Color.accentColor]
        @unknown default:
            return [Color.white.opacity(0.0), Color.accentColor]
        }
    }
}

struct CurrencyPreview_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyPreview(values: [1.1, 1.2, 0.95, 1.11, 1.01, 0.89, 1.22])
            .padding(50)
    }
}
