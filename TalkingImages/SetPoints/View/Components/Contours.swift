import Foundation
import SwiftUI

struct Contours: Shape {
    
    var pointyEars: Bool

    var head1Position: CGPoint
    var head2Position: CGPoint
    var head3Position: CGPoint
    var eye1Position: CGPoint
    var eye2Position: CGPoint
    var mouth1Position: CGPoint
    var mouth2Position: CGPoint
    var mouth3Position: CGPoint
    var chinPosition: CGPoint
    var ear1Position: CGPoint
    var ear2Position: CGPoint

    func path(in rect: CGRect) -> Path {
        let path = CGMutablePath()

        let xDeviation = (head2Position.x - chinPosition.x) / 2
        let yDeviation = (head1Position.y - head3Position.y) / 2

        path.move(to: head1Position)
        if pointyEars {
            path.addQuadCurve(
                to: ear1Position,
                control: CGPoint(
                    x: min(ear1Position.x, head1Position.x),
                    y: ear1Position.y + (head1Position.y - ear1Position.y) / 2
                )
            )
            path.addQuadCurve(
                to: head2Position,
                control: CGPoint(
                    x: ear1Position.x + (head2Position.x - ear1Position.x) / 2 + xDeviation,
                    y: max(head2Position.y, ear1Position.y)
                )
            )
            path.addQuadCurve(
                to: ear2Position,
                control: CGPoint(
                    x: head2Position.x + (ear2Position.x - head2Position.x) / 2 + xDeviation,
                    y: max(head2Position.y, ear2Position.y)
                )
            )
            path.addQuadCurve(
                to: head3Position,
                control: CGPoint(
                    x: max(ear2Position.x, head3Position.x),
                    y: ear2Position.y + (head3Position.y - ear2Position.y) / 2
                )
            )
        } else {
            path.addQuadCurve(
                to: head2Position,
                control: CGPoint(x: head1Position.x + xDeviation, y: head2Position.y + yDeviation)
            )
            path.addQuadCurve(
                to: head3Position,
                control: CGPoint(x: head3Position.x + xDeviation, y: head2Position.y + yDeviation)
            )
        }
        path.addQuadCurve(
            to: chinPosition,
            control: CGPoint(x: head3Position.x + xDeviation, y: chinPosition.y + yDeviation)
        )
        path.addQuadCurve(
            to: head1Position,
            control: CGPoint(x: head1Position.x + xDeviation, y: chinPosition.y + yDeviation)
        )
        path.closeSubpath()

        path.move(to: mouth1Position)
        path.addQuadCurve(
            to: mouth2Position,
            control: CGPoint(x: mouth2Position.x, y: mouth1Position.y)
        )
        path.addQuadCurve(
            to: mouth3Position,
            control: CGPoint(x: mouth2Position.x, y: mouth3Position.y)
        )
        return Path(path)
    }

}
