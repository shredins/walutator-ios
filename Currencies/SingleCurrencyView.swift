//
//  SwiftUIView.swift
//  
//
//  Created by Tomasz Korab on 05/09/2021.
//

import SwiftUI

struct SingleCurrencyView: View {
    
    let fullName: String
    let code: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(code)
                .font(.headline)
            Text(fullName)
                .font(.subheadline)
        }
    }
}

struct SingleCurrencyViewPreviews: PreviewProvider {
    static var previews: some View {
        SingleCurrencyView(fullName: "Dolar amerykański", code: "USD")
    }
}
