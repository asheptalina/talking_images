import Foundation
import SwiftUI

struct LineSegment: Shape {

    let startPoint: CGPoint
    let endPoint: CGPoint

    func path(in rect: CGRect) -> Path {

        var path = Path()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
    }
}
