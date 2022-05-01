import Foundation
import UIKit

enum AppAction {
    case main(action: MainAction)
    case image(action: ImageAction)
    case poins(action: PointsAction)
    case voice(action: VoiceAction)
}

enum MainAction {
    case setPage(_ page: ToolbarPage)
    case showAlert(alertTitle: String, actions: [AlertAction])
    case hideAlert
}

enum ImageAction {
    case setRawImage(_ image: UIImage)
    case setProcessedImage(_ image: UIImage)
}

enum PointsAction {
    case setPointyEars(_ pointyEars: Bool)

    case setDefaultPoins(width: CGFloat)

    case setHead1Position(newPosition: CGPoint)
    case setHead2Position(newPosition: CGPoint)
    case setHead3Position(newPosition: CGPoint)
    case setEye1Position(newPosition: CGPoint)
    case setEye2Position(newPosition: CGPoint)
    case setMouth1Position(newPosition: CGPoint)
    case setMouth2Position(newPosition: CGPoint)
    case setMouth3Position(newPosition: CGPoint)
    case setChinPosition(newPosition: CGPoint)
    case setEar1Position(newPosition: CGPoint)
    case setEar2Position(newPosition: CGPoint)
}

enum VoiceAction {
    case startRecord
    case stopRecord

    case startPlay(onComplete: () -> Void)
    case pausePlay
    case stopPlay

    case setAudioState(_ audioState: AudioState)
    case setSpeed(_ speed: Float)
    case setPitch(_ pitch: Float)
}
