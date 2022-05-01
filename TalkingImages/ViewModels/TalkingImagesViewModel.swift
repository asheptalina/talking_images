import Foundation
import SwiftUI

class TalkingImagesViewModel: ObservableObject {

    //    @Published var toolbarState = ToolbarPage.ChoosePicture
    @Published var rawImage: UIImage?
    @Published var image: UIImage?
    @Published var points: [CGPoint] = []

    func clear() {
        self.image = nil
        self.points = []
    }
}
