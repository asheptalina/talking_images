import SwiftUI

struct ContentView: View {

    @EnvironmentObject var store: AppStore

    let toolbarItems: [ToolbarPage] = [.choosePicture, .edit, .setPoints, .voice, .share]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BACKGROUND_COLOR
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    switch self.store.state.mainState.page {
                    case .choosePicture:
                        ChoosePictureView { image in
                            self.store.send(.image(action: .setRawImage(image)))
                            self.store.send(.main(action: .setPage(.edit)))
                            self.store.send(.main(action: .setReadyForPage(.edit)))
                            self.store.send(.main(action: .setReadyForPage(.setPoints)))
                        }
                    case .edit:
                        EditContainerView()
                    case .setPoints:
                        SetPointsView()
                    case .voice:
                        VoiceView()
                    case .share:
                        ShareView {
                            self.store.send(.main(action: .setPage(.choosePicture)))
                        }
                    }

                    self.getToolbar(screenWidth: geometry.size.width)
                }
                if self.store.state.mainState.showAlert {
                    if let title = self.store.state.mainState.alertTitle,
                       let actions = self.store.state.mainState.alertActions {
                        AlertView(title: title, actions: actions)
                    }
                }
            }
            .onAppear {
                self.store.send(.image(action: .setScreenWidth(geometry.size.width)))
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
                    if self.store.state.mainState.readyForPage.rawValue < item.rawValue {
                        self.store.send(.main(action: .showAlert(
                            alertTitle: "Please complete the previous steps",
                            actions: [
                                AlertAction(label: "OK", action: {
                                    self.store.send(.main(action: .hideAlert))
                                })
                            ]
                        )))
                    } else {
                        self.store.send(.main(action: .setPage(item)))
                    }
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
