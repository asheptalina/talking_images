import SwiftUI
import AVKit

struct ShareView: View {

    @EnvironmentObject var store: AppStore

    var onCreateNewButton: () -> Void

    @State private var videoIsReady = false

    // UI constants
    private let buttonsVerticalPaddingCoef = 0.1

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if self.videoIsReady {
                    VideoPlayer(player: AVPlayer(
                        url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            .appendingPathComponent(VIDEO_FILE_NAME)
                    )).frame(width: geometry.size.width, height: geometry.size.width)
                } else {
                    ZStack {
                        Image(uiImage: self.store.state.imageState.processedImage!)
                            .resizable()
                            .scaledToFit()
                        Color.black.opacity(0.3)
                        ProgressView()
                            .scaleEffect(5, anchor: .center)
                            .progressViewStyle(.circular)
                            .tint(BACKGROUND_COLOR)
                    }.frame(width: geometry.size.width, height: geometry.size.width)
                }
                HStack {
                    downloadButton()
                    shareButton()
                }.padding(.vertical, geometry.size.width * self.buttonsVerticalPaddingCoef)
                createNewButton()
            }
        }
        .onAppear {
            self.video()
        }
    }

    func video() {
        let mouthPoint1 = self.store.state.pointsState.mouth1Position
        let mouthPoint2 = self.store.state.pointsState.mouth2Position
        let mouthPoint3 = self.store.state.pointsState.mouth3Position
        var mouthPoints: [CGPoint] = []
        mouthPoints.append(mouthPoint1)
        mouthPoints.append(CGPoint(
            x: mouthPoint1.x + (mouthPoint2.x - mouthPoint1.x) / 3 * 1.5,
            y: mouthPoint1.y - (mouthPoint1.y - mouthPoint2.y) / 3 * 1.5
        ))
        mouthPoints.append(CGPoint(
            x: mouthPoint1.x + (mouthPoint2.x - mouthPoint1.x) / 3 * 2,
            y: mouthPoint1.y - (mouthPoint1.y - mouthPoint2.y) / 3 * 2
        ))

        mouthPoints.append(mouthPoint2)

        mouthPoints.append(CGPoint(
            x: mouthPoint2.x + (mouthPoint3.x - mouthPoint2.x) / 3 * 1.5,
            y: mouthPoint3.y - (mouthPoint3.y - mouthPoint2.y) / 3 * 2
        ))
        mouthPoints.append(CGPoint(
            x: mouthPoint2.x + (mouthPoint3.x - mouthPoint2.x) / 3 * 2,
            y: mouthPoint3.y - (mouthPoint3.y - mouthPoint2.y) / 3 * 1.5
        ))
        mouthPoints.append(mouthPoint3)

        let imgs = OpenCVWrapper.processImage(
            self.store.state.imageState.processedImage!,
            withMouthPoints: mouthPoints.map { point in
                NSValue(cgPoint: self.toImageSizeCoordinates(
                    point: point,
                    imgSize: self.store.state.imageState.processedImage!.size
                ))
            }
        )!
        store.send(.video(action: .createVideo(audioName: AUDIO_FILE_NAME, images: imgs, onComplete: {
            self.videoIsReady = true
        })))
    }

    private func toImageSizeCoordinates(point: CGPoint, imgSize: CGSize) -> CGPoint {
        return CGPoint(
            x: point.x / self.store.state.imageState.screenWidth! * imgSize.width,
            y: point.y / self.store.state.imageState.screenWidth! * imgSize.height
        )
    }

    func downloadButton() -> some View {
        return Button {
            self.store.send(.video(action: .saveVideo(onComplete: {
                self.store.send(.main(action: .showAlert(
                    alertTitle: "Video has been saved successfully",
                    actions: [AlertAction(label: "OK", action: {self.store.send(.main(action: .hideAlert)) })]
                )))
            })))
        } label: {
            HStack {
                Image("download_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.vertical, 25.0)
                Text("Download")
                    .customFont(.extraBold, .medium, color: .white)
                    .padding(.vertical, 20)
            }.padding(.horizontal, 20)
        }
        .background(DOWNLOAD_BUTTON_COLOR)
        .cornerRadius(10.0)
    }

    func shareButton() -> some View {
        return Button {
            self.actionSheet()
        } label: {
            HStack {
                Image("share_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.vertical, 25.0)
                Text("Share")
                    .customFont(.extraBold, .medium, color: .white)
                    .padding(.vertical, 20)
            }.padding(.horizontal, 20)
        }
        .background(SHARE_BUTTON_COLOR)
        .cornerRadius(10.0)
    }

    private func actionSheet() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent(VIDEO_FILE_NAME)
        let activityVC = UIActivityViewController(activityItems: [fileName], applicationActivities: nil)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }

    func createNewButton() -> some View {
        return Button {
            self.onCreateNewButton()
        } label: {
            HStack {
                Text("Create new animation")
                    .customFont(.extraBold, .medium, color: .white)
                    .padding(.vertical, 20)
            }.padding(.horizontal, 20)
        }
        .background(CREATE_NEW_BUTTON_COLOR)
        .cornerRadius(10.0)
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(onCreateNewButton: {})
    }
}
