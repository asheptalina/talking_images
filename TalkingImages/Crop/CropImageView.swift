import SwiftUI

struct CropImageView: View {

    var cropViewSize: CGSize

    @Binding var rawImage: UIImage?

    @State private var scale: CGFloat = 1.0
    @State var cropSize: CGSize

    @State private var topLeftPoint: CGPoint
    @State private var topRightPoint: CGPoint
    @State private var bottomLeftPoint: CGPoint
    @State private var bottomRightPoint: CGPoint

    @State private var offset = CGSize.zero

    private let minCropSize: CGFloat = 100

    init(cropViewSize: CGSize, rawImage: Binding<UIImage?>) {
        self.cropViewSize = cropViewSize
        self._rawImage = rawImage

        self.cropSize = CGSize(width: cropViewSize.width * 0.8, height: cropViewSize.height * 0.8)
        self.topLeftPoint = CGPoint(x: cropViewSize.width * 0.1, y: cropViewSize.height * 0.1)
        self.topRightPoint = CGPoint(x: cropViewSize.width * 0.9, y: cropViewSize.height * 0.1)
        self.bottomLeftPoint = CGPoint(x: cropViewSize.width * 0.1, y: cropViewSize.height * 0.9)
        self.bottomRightPoint = CGPoint(x: cropViewSize.width * 0.9, y: cropViewSize.height * 0.9)
    }

    var body: some View {
        ZStack {
            self.imageView()
            RectHole(holeSize: self.cropSize, topLeftPoint: self.topLeftPoint, bottomRight: self.bottomRightPoint)
                .fill(Color(UIColor.black.withAlphaComponent(0.5)), style: FillStyle(eoFill: true, antialiased: true))
            self.cropFrame()
        }
        .frame(width: cropViewSize.width, height: cropViewSize.width)
    }

    private func imageView() -> some View {
        return Image(uiImage: self.rawImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(self.scale)
    }

    private func cropFrame() -> some View {
        ZStack {
            self.leftCropLine()
            self.rightCropLine()
            self.topCropLine()
            self.bottomCropLine()

            self.topLeftCropCorner()
            self.topRightCropCorner()
            self.bottomRightCropCorner()
            self.bottomLeftCropCorner()
        }
    }

    private func topLeftCropCorner() -> some View {
        CropCorner(point: self.topLeftPoint, size: 48, cornerDirection: .topleft)
            .stroke(.white, lineWidth: 4)
            .gesture(
                DragGesture().onChanged { value in
                    let maybeNewX = value.location.x
                    if maybeNewX < 1 || self.topRightPoint.x - maybeNewX < self.minCropSize {
                        return
                    }
                    let offset = maybeNewX - self.topLeftPoint.x

                    self.topLeftPoint.x = maybeNewX
                    self.bottomLeftPoint.x = maybeNewX
                    self.topLeftPoint.y += offset
                    self.topRightPoint.y += offset
                }
            )
    }

    private func topRightCropCorner() -> some View {
        CropCorner(point: self.topRightPoint, size: 48, cornerDirection: .topRight)
            .stroke(.white, lineWidth: 4)
            .gesture(
                DragGesture().onChanged { value in
                    let maybeNewX = value.location.x
                    if maybeNewX > self.cropViewSize.width || maybeNewX - self.topLeftPoint.x < self.minCropSize {
                        return
                    }
                    let offset = self.topRightPoint.x - maybeNewX

                    self.topRightPoint.x = maybeNewX
                    self.bottomRightPoint.x = maybeNewX
                    self.topLeftPoint.y += offset
                    self.topRightPoint.y += offset
                }
            )

    }

    private func bottomRightCropCorner() -> some View {
        CropCorner(point: self.bottomRightPoint, size: 48, cornerDirection: .bottomRight)
            .stroke(.white, lineWidth: 4)
            .gesture(
                DragGesture().onChanged { value in
                    let maybeNewX = value.location.x
                    if maybeNewX > self.cropViewSize.width || maybeNewX - self.topLeftPoint.x < self.minCropSize {
                        return
                    }
                    let offset = self.topRightPoint.x - maybeNewX

                    self.topRightPoint.x = maybeNewX
                    self.bottomRightPoint.x = maybeNewX
                    self.bottomLeftPoint.y -= offset
                    self.bottomRightPoint.y -= offset
                }
            )
    }

    private func bottomLeftCropCorner() -> some View {
        CropCorner(point: self.bottomLeftPoint, size: 48, cornerDirection: .bottomLeft)
            .stroke(.white, lineWidth: 4)
            .gesture(
                DragGesture().onChanged { value in
                    let maybeNewX = value.location.x
                    if maybeNewX < 1 || self.topRightPoint.x - maybeNewX < self.minCropSize {
                        return
                    }
                    let offset = maybeNewX - self.topLeftPoint.x

                    self.topLeftPoint.x = maybeNewX
                    self.bottomLeftPoint.x = maybeNewX
                    self.bottomLeftPoint.y -= offset
                    self.bottomRightPoint.y -= offset
                }
            )
    }

    private func leftCropLine() -> some View {
        self.cropLine(startPoint: self.topLeftPoint, endPoint: self.bottomLeftPoint) { value in
            let maybeNewX = value.location.x
            if maybeNewX < 1 || self.topRightPoint.x - maybeNewX < self.minCropSize {
                return
            }
            let offset = maybeNewX - self.topLeftPoint.x

            self.topLeftPoint.x = maybeNewX
            self.bottomLeftPoint.x = maybeNewX
            self.bottomLeftPoint.y -= offset
            self.bottomRightPoint.y -= offset
        }
    }

    private func rightCropLine() -> some View {
        self.cropLine(startPoint: self.topRightPoint, endPoint: self.bottomRightPoint) { value in
            let maybeNewX = value.location.x
            if maybeNewX > self.cropViewSize.width || maybeNewX - self.topLeftPoint.x < self.minCropSize {
                return
            }
            let offset = self.topRightPoint.x - maybeNewX

            self.topRightPoint.x = maybeNewX
            self.bottomRightPoint.x = maybeNewX
            self.topLeftPoint.y += offset
            self.topRightPoint.y += offset
        }
    }

    private func topCropLine() -> some View {
        self.cropLine(startPoint: self.topLeftPoint, endPoint: self.topRightPoint) { value in
            let maybeNewY = value.location.y
            if maybeNewY < 1 || self.bottomLeftPoint.y - maybeNewY < self.minCropSize {
                return
            }
            let offset = self.topRightPoint.y - maybeNewY

            self.topRightPoint.y = maybeNewY
            self.topLeftPoint.y = maybeNewY
            self.bottomRightPoint.x += offset
            self.topRightPoint.x += offset
        }
    }

    private func bottomCropLine() -> some View {
        self.cropLine(startPoint: self.bottomLeftPoint, endPoint: self.bottomRightPoint) { value in
            let maybeNewY = value.location.y
            if maybeNewY > self.cropViewSize.height || maybeNewY - self.topLeftPoint.y < self.minCropSize {
                return
            }
            let offset = maybeNewY - self.bottomLeftPoint.y

            self.bottomLeftPoint.y = maybeNewY
            self.bottomRightPoint.y = maybeNewY
            self.bottomLeftPoint.x -= offset
            self.topLeftPoint.x -= offset
        }
    }

    private func cropLine(
        startPoint: CGPoint,
        endPoint: CGPoint,
        dragAction: @escaping (DragGesture.Value) -> Void
    ) -> some View {
        LineSegment(startPoint: startPoint, endPoint: endPoint)
            .stroke(.white, lineWidth: 1)
            .gesture(
                DragGesture()
                    .onChanged(dragAction)
            )
    }

}

struct CropImageView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            CropImageView(
                cropViewSize: CGSize(width: geometry.size.width, height: geometry.size.width),
                rawImage: .constant(UIImage(named: "default_picture_1"))
            )
        }
    }
}
