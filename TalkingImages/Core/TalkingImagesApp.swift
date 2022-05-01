import SwiftUI

@main
struct TalkingImagesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(
                    AppStore(
                        initialState: AppState(
                            mainState: MainState(),
                            imageState: ImageState(),
                            pointsState: PointsState(),
                            voiceState: VoiceState()
                        ),
                        reducer: appReducer,
                        environment: AppEnvironment()
                    )
                )
                .environmentObject(TalkingImagesViewModel())
                .environmentObject(VoiceViewModel())
        }
    }
}
