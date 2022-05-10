import SwiftUI

struct VoiceView: View {

    @EnvironmentObject var store: AppStore

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(uiImage: store.state.imageState.processedImage!)
                    .resizable()
                    .scaledToFit()

                switch self.store.state.voiceState.audioState {
                case .empty:
                    self.recordView(width: geometry.size.width)
                case .recording:
                    self.recordView(width: geometry.size.width)
                case .readyToPlay:
                    self.playView(width: geometry.size.width)
                case .playing:
                    self.playView(width: geometry.size.width)
                }
            }
        }.onAppear {
            self.store.send(.main(action: .setReadyForPage(.share)))
        }
    }

    private func recordView(width: CGFloat) -> some View {
        RecordView(
            timeRemaining: self.store.state.voiceState.maxAudioDurationInSeconds,
            maxAudioDurationInSeconds: self.store.state.voiceState.maxAudioDurationInSeconds,
            width: width,
            onStartRecord: {
                self.store.send(.voice(action: .startRecord))
            },
            onEndRecord: {
                self.store.send(.voice(action: .stopRecord))
            }
        )
    }

    private func playView(width: CGFloat) -> some View {
        PlayView(
            isPlaying: self.store.state.voiceState.audioState == .playing,
            speedValue: self.store.state.voiceState.speedValue,
            pitchValue: self.store.state.voiceState.pitchValue,
            width: width,
            onStartPlaying: {
                self.store.send(.voice(action: .startPlay(onComplete: {
                    self.store.send(.voice(action: .setAudioState(.readyToPlay)))
                })))
            },
            onStopPlaying: {
                self.store.send(.voice(action: .stopPlay))
            },
            onRecordAgain: {
                self.store.send(.main(
                    action: .showAlert(
                        alertTitle: "Cancel this recording and create a new one?",
                        actions: [
                            AlertAction(label: "Back", isCancel: true, action: {
                                self.store.send(.main(action: .hideAlert))
                            }),
                            AlertAction(label: "Record again", action: {
                                self.store.send(.main(action: .hideAlert))
                                self.store.send(.voice(action: .setAudioState(.empty)))
                            })
                        ]
                    )
                ))
            }
        )
    }
}

struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView()
    }
}
