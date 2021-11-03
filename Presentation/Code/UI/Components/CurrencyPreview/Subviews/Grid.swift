import SwiftUI

struct Grid: View {
    
    let xGranularity: Int
    let yGranularity: Int
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                ForEach(0..<xGranularity) { _ in
                    Color(.separator).frame(width: 1).opacity(0.3)
                    Spacer()
                }
//                Color(.separator).frame(width: 1).opacity(0.3)
            }
            VStack {
//                Color(.separator).frame(height: 1).opacity(0.3)
                Spacer()
                ForEach(0..<yGranularity) { _ in
                    Color(.separator).frame(height: 1).opacity(0.3)
                    Spacer()
                }
//                Color(.separator).frame(height: 1).opacity(0.3)
            }
        }
    }
}

struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        Grid(xGranularity: 3, yGranularity: 3)
    }
}
