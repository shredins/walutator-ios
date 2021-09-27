import SwiftUI

struct ChartBuilder {
    
    let proportions: [CGFloat]
    let max: Double
    let closed: Bool
    
    init(values: [Double], closed: Bool) {
        let min = values.min() ?? 0
        let adjusted = values.map { $0 - min }
        let max = adjusted.max() ?? 0
        
        self.proportions = adjusted.map { CGFloat($0 / max) }
        self.max = max
        self.closed = closed
    }
    
    func modify(path: inout Path, for size: CGSize) {
        let xOffset = size.width / CGFloat(proportions.count - 1)
        
        var previousPoint: CGPoint?
        
        proportions
            .enumerated()
            .map { index, proportion in
                CGPoint(x: CGFloat(index) * xOffset, y: proportion * size.height)
            }
            .enumerated()
            .forEach { index, point in
                
                switch index {
                case 0:
                    path.move(to: point)
                default:
                    guard let previousPoint = previousPoint else {
                        fatalError("Missing required point")
                    }
                    
                    let deltaX = point.x - previousPoint.x
                    let curveXOffset = deltaX * 0.4


                    path.addCurve(to: point,
                                  control1: .init(x: previousPoint.x + curveXOffset, y: previousPoint.y),
                                  control2: .init(x: point.x - curveXOffset, y: point.y ))
                    
                    if index == proportions.count - 1 && closed {
                        path.addLine(to: CGPoint(x: point.x, y: 0))
                        path.addLine(to: CGPoint(x: 0, y: 0))
                    }
                }
                
                previousPoint = point
            }
    }
}
