import Foundation
import SwiftUI

class TalkingImagesViewModel: ObservableObject {

    //    @Published var toolbarState = ToolbarPage.ChoosePicture
    @Published var rawImage: Image?
    @Published var image: Image?
    @Published var points: [CGPoint] = []

    func clear() {
        self.image = nil
        self.points = []
    }
}
