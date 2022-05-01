import Foundation
import SwiftUI

struct RectHole: Shape {
    let holeSize: CGSize

    let topLeftPoint: CGPoint
    let bottomRight: CGPoint

    func path(in rect: CGRect) -> Path {
        let path = CGMutablePath()
        path.move(to: rect.origin)
        path.addLine(to: .init(x: rect.maxX, y: rect.minY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.addLine(to: rect.origin)
        path.closeSubpath()

        let newRect = CGRect(
            origin: .init(x: rect.midX - holeSize.width/2.0, y: rect.midY - holeSize.height/2.0),
            size: holeSize
        )

        path.move(to: self.topLeftPoint)
        path.addLine(to: .init(x: bottomRight.x, y: topLeftPoint.y))
        path.addLine(to: .init(x: bottomRight.x, y: bottomRight.y))
        path.addLine(to: .init(x: topLeftPoint.x, y: bottomRight.y))
        path.addLine(to: self.topLeftPoint)
        path.closeSubpath()
        return Path(path)
    }
}
