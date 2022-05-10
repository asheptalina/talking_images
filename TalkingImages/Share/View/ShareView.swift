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
                    Image(uiImage: self.store.state.imageState.processedImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.width)
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
        let imgs = OpenCVWrapper.processImage(
            self.store.state.imageState.processedImage!,
            withMouthPoints: [
                NSValue(cgPoint: self.store.state.pointsState.mouth1Position),
                NSValue(cgPoint: self.store.state.pointsState.mouth2Position),
                NSValue(cgPoint: self.store.state.pointsState.mouth3Position)
            ]
        )!
        store.send(.video(action: .createVideo(audioName: AUDIO_FILE_NAME, images: imgs, onComplete: {
            self.videoIsReady = true
        })))
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
