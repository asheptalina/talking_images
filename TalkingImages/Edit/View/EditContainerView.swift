import SwiftUI

struct EditContainerView: View {

    @EnvironmentObject var store: AppStore

    var body: some View {
        GeometryReader { geometry in
            self.content(geometry: geometry)
        }
    }

    private func content(geometry: GeometryProxy) -> some View {
        let imgSize = self.store.state.imageState.rawImage?.size ?? CGSize(width: 1, height: 1)

        let topLeftPoint: CGPoint
        if let topLeft = self.store.state.imageState.cropTopLeftPoint {
            topLeftPoint = CGPoint(
                x: topLeft.x / imgSize.width * geometry.size.width,
                y: topLeft.y / imgSize.height * geometry.size.width
            )
        } else {
            topLeftPoint = CGPoint(x: geometry.size.width * 0.1, y: geometry.size.width * 0.1)
        }

        let bottomRightPoint: CGPoint
        if let bottomRight = self.store.state.imageState.cropBottomRightPoint {
            bottomRightPoint = CGPoint(
                x: bottomRight.x / imgSize.width * geometry.size.width,
                y: bottomRight.y / imgSize.height * geometry.size.width
            )
        } else {
            bottomRightPoint = CGPoint(x: geometry.size.width * 0.9, y: geometry.size.width * 0.9)
        }

        let image = self.store.state.imageState.rawImage ?? UIImage()
        var rotatedImage: UIImage?
        if self.store.state.imageState.rotateDegrees != 0 {
            rotatedImage = image.rotate(degrees: self.store.state.imageState.rotateDegrees)
        }
        return EditView(
            image: rotatedImage ?? image,
            topLeftPoint: topLeftPoint,
            bottomRightPoint: bottomRightPoint,
            rotateDegrees: self.store.state.imageState.rotateDegrees
        ) { topLeft, bottomRight, degress in
            self.store.send(.image(action: .setCropPoints(topLeft: topLeft, bottomRight: bottomRight)))
            self.store.send(.image(action: .setRotateDegress(degress)))
            self.store.send(.image(action: .cropImage))
        }
    }
}

struct EditContainerView_Previews: PreviewProvider {
    static var previews: some View {
        EditContainerView()
    }
}
