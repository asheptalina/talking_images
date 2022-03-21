import SwiftUI

struct EditViewView: View {
    
    @EnvironmentObject var viewModel: TalkingImagesViewModel
    
    private let title = "Crop and rotate the picture"
    
    // UI constants 
    private let rotateButtonHeightCoef = 0.15
    private let titlePaddingCoef = 0.07
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CropImageView(
                    cropViewSize: CGSize(width: geometry.size.width, height: geometry.size.width), 
                    rawImage: self.$viewModel.rawImage
                )
                
                Text(self.title)
                    .customFont(.semiBold, .medium)
                    .padding(.vertical, geometry.size.height * self.titlePaddingCoef)
                self.rotateButtons(height: self.rotateButtonHeightCoef * geometry.size.height)
                
                Spacer()
            }
        }
        .onAppear(perform: { 
            self.viewModel.image = self.viewModel.rawImage  // TODO: crop
        })
        .onChange(of: self.viewModel.rawImage) { newValue in
            self.viewModel.image = newValue
        }
    }
    
    private func rotateButtons(height: CGFloat) -> some View {
        return HStack {
            Button { 
                // TODO: rotate
            } label: { 
                Image(ROTATE_LEFT_ICON)
                    .resizable()
                    .scaledToFit()
            }
            Button { 
                // TODO: rotate
            } label: { 
                Image(ROTATE_RESET_ICON)
                    .resizable()
                    .scaledToFit()
                    .frame(height: height * 0.8)
            }
            Button { 
                // TODO: rotate
            } label: { 
                Image(ROTATE_RIGHT_ICON)
                    .resizable()
                    .scaledToFit()
            }
        }.frame(height: height)
    }
}

struct EditViewView_Previews: PreviewProvider {
    static var previews: some View {
        EditViewView()
    }
}
