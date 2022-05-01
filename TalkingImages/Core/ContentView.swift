import SwiftUI

struct ContentView: View {

    @EnvironmentObject var store: AppStore

    let toolbarItems: [ToolbarPage] = [.choosePicture, .edit, .setPoints, .voice, .share]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BACKGROUND_COLOR
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    switch self.store.state.mainState.page {
                    case .choosePicture:
                        ChoosePictureView { image in
                            self.store.send(.image(action: .setRawImage(image)))
                            self.store.send(.main(action: .setPage(.edit)))
                        }
                    case .edit:
                        EditViewView(
                            image: self.store.state.imageState.rawImage,
                            onEditImage: { image in
                                self.store.send(.image(action: .setProcessedImage(image)))
                            })
                    case .setPoints:
                        SetPointsView()
                    case .voice:
                        VoiceView()
                    case .share:
                        ShareView {
                            self.store.send(.main(action: .setPage(.choosePicture)))
                        }
                    }

                    Spacer()
                }
                VStack {
                    Spacer()
                    self.getToolbar(screenWidth: geometry.size.width)
                }
                if self.store.state.mainState.showAlert {
                    if let title = self.store.state.mainState.alertTitle,
                       let actions = self.store.state.mainState.alertActions {
                        AlertView(title: title, actions: actions)
                    }
                }
            }
        }.edgesIgnoringSafeArea(.bottom)
    }

    private func getToolbar(screenWidth: CGFloat) -> some View {
        return ZStack(alignment: .bottomLeading) {
            ForEach((1...self.toolbarItems.count).reversed(), id: \.self) { idx in
                let item = self.toolbarItems[idx - 1]
                MenuButton(
                    imageName: item.imageName,
                    color: item.color,
                    isActive: self.store.state.mainState.page == item,
                    itemIndex: idx,
                    itemWidth: screenWidth / 5.0
                ) {
                    self.store.send(.main(action: .setPage(item)))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
