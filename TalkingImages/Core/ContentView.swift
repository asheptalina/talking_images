import SwiftUI

struct ContentView: View {
    
    @State var toolbarState = ToolbarPage.ChoosePicture
    
    let toolbarItems: [ToolbarPage] = [.ChoosePicture, .Edit, .SetPoints, .Voice, .Share]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    switch toolbarState {
                    case .ChoosePicture:
                        ChoosePictureView { 
                            self.toolbarState = .Edit
                        }
                    case .Edit:
                        EditViewView()
                    case .SetPoints:
                        SetPointsView()
                    case .Voice:
                        VoiceView()
                    case .Share:
                        ShareView { 
                            self.toolbarState = .ChoosePicture
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
