import SwiftUI

struct ContentView: View {
    
    @State var toolbarState = ToolbarPage.Edit
    
    let toolbarItems: [ToolbarPage] = [.ChoosePicture, .Edit, .SetPoints, .Voice, .Share]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                switch toolbarState {
                case .ChoosePicture:
                    ChoosePictureView()
                case .Edit:
                    EditViewView()
                case .SetPoints:
                    SetPointsView()
                case .Voice:
                    VoiceView()
                case .Share:
                    ShareView()
                }
               
                Spacer()
                
                self.getToolbar(screenWidth: geometry.size.width)
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    private func getToolbar(screenWidth: CGFloat) -> some View {
        return ZStack(alignment: .bottomLeading) {
            ForEach((1...self.toolbarItems.count).reversed(), id: \.self) { idx in
                let item = self.toolbarItems[idx - 1]
                let itemWidth: CGFloat = screenWidth / 5.0 * CGFloat(idx)
                MenuButton(imageName: item.imageName, color: item.color, isActive: self.toolbarState == item, width: itemWidth) {
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
