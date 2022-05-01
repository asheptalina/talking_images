import Foundation
import SwiftUI

enum CornerDirection {
    case topleft
    case topRight
    case bottomRight
    case bottomLeft
}

struct CropCorner: Shape {

    let point: CGPoint
    let size: CGFloat
    let cornerDirection: CornerDirection

    func path(in rect: CGRect) -> Path {

        var path = Path()
        switch self.cornerDirection {
        case .topleft:
            path.move(to: CGPoint(x: self.point.x, y: self.point.y + size))
            path.addLine(to: self.point)
            path.addLine(to: CGPoint(x: self.point.x + size, y: self.point.y))
        case .topRight:
            path.move(to: CGPoint(x: self.point.x - size, y: self.point.y))
            path.addLine(to: self.point)
            path.addLine(to: CGPoint(x: self.point.x, y: self.point.y + size))
        case .bottomRight:
            path.move(to: CGPoint(x: self.point.x, y: self.point.y - size))
            path.addLine(to: self.point)
            path.addLine(to: CGPoint(x: self.point.x - size, y: self.point.y))
        case .bottomLeft:
            path.move(to: CGPoint(x: self.point.x, y: self.point.y - size))
            path.addLine(to: self.point)
            path.addLine(to: CGPoint(x: self.point.x + size, y: self.point.y))
        }

        return path
    }
}
