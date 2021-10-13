import SwiftUI

struct Spacing: View {
    
    let height: CGFloat
    
    init(_ height: CGFloat) {
        self.height = height
    }
    
    var body: some View {
        Color
            .clear
            .frame(height: height)
    }
}

struct Spacing_Previews: PreviewProvider {
    static var previews: some View {
        Spacing(0)
    }
}
