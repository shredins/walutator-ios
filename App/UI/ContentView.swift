import SwiftUI

struct ContentView: View {
    
    let myMoneyColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible())
    ]
    
    let money: [Color] = [
        Color.wtOrange,
        Color.wtRed,
        Color.wtGreen
    ]
    
    let currencies: [String] = [
        "GBP", "USD", "EUR", "CAD", "AUD", "JPY", "CZK", "DKK", "NOK", "SEK", "XDR"
    ]
    
    let exchangeRates: [(String, Double)] = [
        ("28.09.2021", 3.95),
        ("27.09.2021", 3.92),
        ("26.09.2021", 3.97),
        ("25.09.2021", 3.91),
        ("24.09.2021", 3.93)
    ]
    
    let currenciesColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Header("Moje środki")
                        Button("Zarządzaj") {
                            
                        }
                    }
                        .padding([.horizontal, .top], 22)
                    Spacing(20)
                    LazyVGrid(columns: myMoneyColumns, spacing: 20) {
                        ForEach(0..<money.count) {
                            money[$0]
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacing(20)
                    ZStack(alignment: .leading) {
                        Color
                            .gray
                            .opacity(0.1)
                        VStack(alignment: .leading, spacing: 0) {
                            Header("Zestawienie")
                            Spacing(15)
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("4 500,99 zł")
                                        .font(.largeTitle)
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 25, weight: .light))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                Text("+19,99 zł (2,05%)")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                Spacing(20)
                                HStack {
                                    Header("Dolar amerykański")
                                    Button("Historia") {
                                        
                                    }
                                }
                            }
                        }
                        .padding(22)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    ZStack {
                        LinearGradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0)],
                                       startPoint: .top,
                                       endPoint: .bottom)
                        CurrencyPreview(values: [1, 2, 4, 1, 6, 7, 1, 2, 5, 10, 5])
                            .frame(height: 150)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    Spacing(60)
                    LazyVGrid(columns: currenciesColumns, spacing: 10) {
                        ForEach(0..<currencies.count) { index in
                            ZStack {
                                Color
                                    .accentColor
                                    .opacity(0.7)
                                    .cornerRadius(12)
                                Text(currencies[index])
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(10)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitle("WALUTATOR", displayMode: .large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
