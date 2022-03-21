import SwiftUI

struct ContentView: View {

    @State var toolbarState = ToolbarPage.choosePicture

    let toolbarItems: [ToolbarPage] = [.choosePicture, .edit, .setPoints, .voice, .share]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    switch toolbarState {
                    case .choosePicture:
                        ChoosePictureView {
                            self.toolbarState = .edit
                        }
                    case .edit:
                        EditViewView()
                    case .setPoints:
                        SetPointsView()
                    case .voice:
                        VoiceView()
                    case .share:
                        ShareView {
                            self.toolbarState = .choosePicture
                        }
                    }

                    Spacer()
                }
                VStack {
                    Spacer()
                    self.getToolbar(screenWidth: geometry.size.width)
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
                    isActive: self.toolbarState == item,
                    itemIndex: idx,
                    itemWidth: screenWidth / 5.0
                ) {
                    self.toolbarState = item
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
