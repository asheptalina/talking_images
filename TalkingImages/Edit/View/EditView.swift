import SwiftUI

struct EditView: View {

    @EnvironmentObject var store: AppStore

    @State var image: UIImage?
    
    var onEditImage: (UIImage) -> Void

    private let title = "Crop and rotate the picture"

    @State private var rotateDegrees: Float = 0
    @State private var topLeftPoint = CGPoint.zero
    @State private var bottomRightPoint = CGPoint.zero

    // UI constants 
    private let rotateButtonHeightCoef = 0.15
    private let titlePaddingCoef = 0.07

    var body: some View {
        GeometryReader { geometry in
            VStack {
                CropImageView(
                    cropViewSize: CGSize(width: geometry.size.width, height: geometry.size.width),
                    rawImage: self.$image,
                    topLeft: self.$topLeftPoint,
                    bottomRight: self.$bottomRightPoint
                )

                Text(self.title)
                    .customFont(.semiBold, .medium, color: TEXT_COLOR)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, geometry.size.height * self.titlePaddingCoef)
                self.rotateButtons(height: self.rotateButtonHeightCoef * geometry.size.height)

                Spacer()
            }.onAppear {
                self.topLeftPoint = self.store.state.imageState.cropTopLeftPoint
                    ?? CGPoint(x: geometry.size.width * 0.1, y: geometry.size.width * 0.1)
                self.bottomRightPoint = self.store.state.imageState.cropBottomRightPoint
                    ?? CGPoint(x: geometry.size.width * 0.9, y: geometry.size.width * 0.9)
            }
        }
        .onAppear(perform: {
            if let img = image {
                self.onEditImage(img)
            }
        })
        .onDisappear {
            self.store.send(.image(
                action: .setCropPoints(topLeft: self.topLeftPoint, bottomRight: self.bottomRightPoint)
            ))
            self.store.send(.image(action: .cropImage))
        }
    }

    private func rotateButtons(height: CGFloat) -> some View {
        return HStack {
            Button {
                if let img = self.image?.rotate(degrees: -15) {
                    self.image = img
                    self.onEditImage(img)
                    self.rotateDegrees -= 15
                }
            } label: {
                Image(ROTATE_LEFT_ICON)
                    .resizable()
                    .scaledToFit()
            }
            Button {
                if let img = self.image?.rotate(degrees: -self.rotateDegrees) {
                    self.image = img
                    self.onEditImage(img)
                    self.rotateDegrees = 0
                }
            } label: {
                Image(ROTATE_RESET_ICON)
                    .resizable()
                    .scaledToFit()
                    .frame(height: height * 0.8)
            }
            Button {
                if let img = self.image?.rotate(degrees: 15) {
                    self.image = img
                    self.onEditImage(img)
                    self.rotateDegrees += 15
                }
            } label: {
                Image(ROTATE_RIGHT_ICON)
                    .resizable()
                    .scaledToFit()
            }
        }.frame(height: height)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(image: UIImage(named: "default_picture_1"), onEditImage: { _ in })
    }
}
