import Foundation
import AVFoundation
import UIKit

struct AppState {
    var mainState: MainState
    var imageState: ImageState
    var pointsState: PointsState
    var voiceState: VoiceState
}

struct MainState {
    var page: ToolbarPage = .choosePicture

    var showAlert = false
    var alertTitle: String?
    var alertActions: [AlertAction]?
}

struct ImageState {
    var rawImage: UIImage?
    var processedImage: UIImage?
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
    var audioState = AudioState.empty

    var maxAudioDurationInSeconds = 30

    var speedValue: Float = 1.0
    var pitchValue: Float = 0.0
}

