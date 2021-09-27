import SwiftUI

struct LineGraph: Shape {
    
    let values: [Double]
    let closed: Bool

    func path(in rect: CGRect) -> Path {
        Path { path in
            ChartBuilder(values: values, closed: closed).modify(path: &path, for: rect.size)
        }
    }
}

