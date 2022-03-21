import SwiftUI

@main
struct TalkingImagesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(TalkingImagesViewModel())
                .environmentObject(VoiceViewModel())
        }
    }
}
