import Foundation
import AVFAudio
import AVFoundation

typealias AppStore = Store<AppState, AppAction, AppEnvironment>

func appReducer(state: inout AppState, action: AppAction, environment: AppEnvironment) {
    switch action {
    case .main(action: let action):
        mainReducer(state: &state.mainState, action: action, environment: environment)
    case .image(action: let action):
        imageReducer(state: &state.imageState, action: action, environment: environment)
    case .poins(action: let action):
        pointsReducer(state: &state.pointsState, action: action, environment: environment)
    case .voice(action: let action):
        voiceReducer(state: &state.voiceState, action: action, environment: environment)
    }
}

func mainReducer(state: inout MainState, action: MainAction, environment: AppEnvironment) {
    switch action {
    case .setPage(let page):
        state.page = page
    case .showAlert(alertTitle: let alertTitle, actions: let actions):
        state.showAlert = true
        state.alertTitle = alertTitle
        state.alertActions = actions
    case .hideAlert:
        state.showAlert = false
        state.alertTitle = nil
        state.alertActions = nil
    }
}

func imageReducer(state: inout ImageState, action: ImageAction, environment: AppEnvironment) {
    switch action {
    case .setRawImage(let image):
        state.rawImage = image
    case .setProcessedImage(let image):
        state.processedImage = image
    }
}

func pointsReducer(state: inout PointsState, action: PointsAction, environment: AppEnvironment) {
    switch action {
    case .setDefaultPoins(let width):
        state.pointsAreSetted = false
        state.ear1Position = CGPoint(x: width * 0.28, y: width * 0.15)
        state.ear2Position = CGPoint(x: width * 0.73, y: width * 0.15)
        state.head1Position = CGPoint(x: width * 0.3, y: width * 0.3)
        state.head2Position = CGPoint(x: width * 0.52, y: width * 0.19)
        state.head3Position = CGPoint(x: width * 0.72, y: width * 0.3)
        state.eye1Position = CGPoint(x: width * 0.42, y: width * 0.39)
        state.eye2Position = CGPoint(x: width * 0.58, y: width * 0.39)
        state.chinPosition = CGPoint(x: width * 0.49, y: width * 0.59)
        state.mouth1Position = CGPoint(x: width * 0.44, y: width * 0.55)
        state.mouth2Position = CGPoint(x: width * 0.49, y: width * 0.51)
        state.mouth3Position = CGPoint(x: width * 0.54, y: width * 0.55)
    case .setPointyEars(let pointyEars):
        state.pointyEars = pointyEars
    case .setHead1Position(let newPosition):
        state.pointsAreSetted = true
        state.head1Position = newPosition
    case .setHead2Position(let newPosition):
        state.pointsAreSetted = true
        state.head2Position = newPosition
    case .setHead3Position(let newPosition):
        state.pointsAreSetted = true
        state.head3Position = newPosition
    case .setEye1Position(let newPosition):
        state.pointsAreSetted = true
        state.eye1Position = newPosition
    case .setEye2Position(let newPosition):
        state.pointsAreSetted = true
        state.eye2Position = newPosition
    case .setMouth1Position(let newPosition):
        state.pointsAreSetted = true
        state.mouth1Position = newPosition
    case .setMouth2Position(let newPosition):
        state.pointsAreSetted = true
        state.mouth2Position = newPosition
    case .setMouth3Position(let newPosition):
        state.pointsAreSetted = true
        state.mouth3Position = newPosition
    case .setChinPosition(let newPosition):
        state.pointsAreSetted = true
        state.chinPosition = newPosition
    case .setEar1Position(let newPosition):
        state.pointsAreSetted = true
        state.ear1Position = newPosition
    case .setEar2Position(let newPosition):
        state.pointsAreSetted = true
        state.ear2Position = newPosition
    }
}

func voiceReducer(state: inout VoiceState, action: VoiceAction, environment: AppEnvironment) {
    switch action {
    case .startRecord:
        environment.voiceService.startRecord()
        state.audioState = .recording
    case .stopRecord:
        environment.voiceService.stopRecord()
        state.audioState = .readyToPlay
    case .startPlay(let onComplete):
        environment.voiceService.startPlay(
            speedValue: state.speedValue,
            pitchValue: state.pitchValue,
            onComplete: onComplete
        )
        state.audioState = .playing
    case .pausePlay:
        print("")
    case .stopPlay:
        environment.voiceService.stopPlay()
        state.audioState = .readyToPlay
    case .setAudioState(let audioState):
        state.audioState = audioState
    case .setSpeed(let speed):
        state.speedValue = speed
    case .setPitch(let pitch):
        state.pitchValue = pitch
    }
}
