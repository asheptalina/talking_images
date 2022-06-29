import Foundation
import AVFoundation
import UIKit

struct AppState {
    var mainState: MainState
    var imageState: ImageState
    var pointsState: PointsState
    var voiceState: VoiceState
    var videoState: VideoState
}

struct MainState {
    var page: ToolbarPage = .choosePicture
    var readyForPage: ToolbarPage = .choosePicture

    var showAlert = false
    var alertTitle: String?
    var alertActions: [AlertAction]?
}

struct ImageState {
    var screenWidth: CGFloat?
    var rawImage: UIImage?
    var processedImage: UIImage?

    // Points are saved in image-sized coordinates
    var cropTopLeftPoint: CGPoint?
    var cropBottomRightPoint: CGPoint?

    var rotateDegrees: Float = 0
}

struct PointsState {
    var pointyEars = true
    var pointsAreSetted = false
    var head1Position = CGPoint(x: 0, y: 0)
    var head2Position = CGPoint(x: 0, y: 0)
    var head3Position = CGPoint(x: 0, y: 0)
    var eye1Position = CGPoint(x: 0, y: 0)
    var eye2Position = CGPoint(x: 0, y: 0)
    var mouth1Position = CGPoint(x: 0, y: 0)
    var mouth2Position = CGPoint(x: 0, y: 0)
    var mouth3Position = CGPoint(x: 0, y: 0)
    var chinPosition = CGPoint(x: 0, y: 0)
    var ear1Position = CGPoint(x: 0, y: 0)
    var ear2Position = CGPoint(x: 0, y: 0)
}

enum AudioState {
    case empty
    case recording
    case readyToPlay
    case playing
}

struct VoiceState {
    var audioFileUrl: URL?

    var audioState = AudioState.empty

    var speedValue: Float = 1.0
    var pitchValue: Float = 0.0
}

struct VideoState {
    
}
