import SwiftUI

struct Header: View {
    
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(text))
                .font(.headline)
            Spacer()
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header("Header")
    }
}
