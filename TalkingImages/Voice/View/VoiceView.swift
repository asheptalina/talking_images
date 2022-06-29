import SwiftUI

struct VoiceView: View {

    @EnvironmentObject var store: AppStore

    @State var showDefaultSounds = false

    @State private var defaultSounds = [
        AudioFile(name: "I love you", fileName: "i_love_you", type: "mp3"),
        AudioFile(name: "Happy birthday", fileName: "happy_birthday", type: "mp3"),
        AudioFile(name: "Dog barking", fileName: "dog", type: "mp3"),
        AudioFile(name: "Cat meowing", fileName: "cat", type: "mp3"),
        AudioFile(name: "Jingle bells", fileName: "jingle_bell", type: "mp3"),
        AudioFile(name: "I love you 2", fileName: "i_love_you", type: "mp3"),
        AudioFile(name: "Happy birthday 2", fileName: "happy_birthday", type: "mp3"),
        AudioFile(name: "Dog barking 2", fileName: "dog", type: "mp3"),
        AudioFile(name: "Cat meowing 2", fileName: "cat", type: "mp3"),
        AudioFile(name: "Jingle bells 2", fileName: "jingle_bell", type: "mp3"),
        AudioFile(name: "I love you 3", fileName: "i_love_you", type: "mp3"),
        AudioFile(name: "Happy birthday 3", fileName: "happy_birthday", type: "mp3"),
        AudioFile(name: "Dog barking 3", fileName: "dog", type: "mp3"),
        AudioFile(name: "Cat meowing 3", fileName: "cat", type: "mp3"),
        AudioFile(name: "Jingle bells 3", fileName: "jingle_bell", type: "mp3")
    ]

    // UI constants
    private let paddingTopCoef = 0.09
    private let openDefaultSoundsButtonPaddingCoef = 0.07
    private let openDefaultSoundsIconSizeCoef = 0.07
    private let openDefaultSoundsButtonSizeCoef = 0.17
    private let playDefaultSoundButtonSizeCoef = 0.1

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Image(uiImage: store.state.imageState.processedImage!)
                        .resizable()
                        .scaledToFit()

                    ZStack {
                        switch self.store.state.voiceState.audioState {
                        case .empty:
                            self.recordView(width: geometry.size.width)
                                .padding(.top, geometry.size.width * self.paddingTopCoef)
                        case .recording:
                            self.recordView(width: geometry.size.width)
                                .padding(.top, geometry.size.width * self.paddingTopCoef)
                        case .readyToPlay:
                            self.playView(width: geometry.size.width)
                                .padding(.top, geometry.size.width * self.paddingTopCoef)
                        case .playing:
                            self.playView(width: geometry.size.width)
                                .padding(.top, geometry.size.width * self.paddingTopCoef)
                        }

                        if !self.showDefaultSounds {
                            HStack {
                                Spacer()
                                self.showDefaultSoundsButton(isOpen: self.showDefaultSounds, geometry: geometry)
                                    .padding(.top, geometry.size.width * self.openDefaultSoundsButtonPaddingCoef)
                            }
                        }
                    }
                    Spacer()
                }
                if self.showDefaultSounds {
                    self.defaultSoundsView(geometry: geometry)
                }
            }
        }.onAppear {
            self.store.send(.main(action: .setReadyForPage(.share)))
        }
    }

    private func defaultSoundsView(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Spacer()
            self.showDefaultSoundsButton(isOpen: true, geometry: geometry)
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(DEFAULT_SOUNDS_COLOR.opacity(0.9))
                ScrollView(showsIndicators: true) {
                    ForEach(self.defaultSounds) { sound in
                        ZStack {
                            HStack {
                                Button {
                                    self.store.send(.voice(action: .startPlay(onComplete: {
                                        // TODO: compl
                                    })))
                                } label: {
                                    Image(DEFAULT_PLAY_ICON)
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(
                                    width: geometry.size.width * self.playDefaultSoundButtonSizeCoef,
                                    height: geometry.size.width * self.playDefaultSoundButtonSizeCoef
                                )
                                .padding(.all, 15)

                                Spacer()

                                if sound.selected {
                                    Image(DEFAULT_SELECTED_ICON)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            width: geometry.size.width * self.playDefaultSoundButtonSizeCoef,
                                            height: geometry.size.width * self.playDefaultSoundButtonSizeCoef
                                        )
                                        .padding(.all, 15)
                                }
                            }
                            Button {
                                self.store.send(.voice(action: .setAudioFileUrl(sound.url)))
                                self.defaultSounds = self.defaultSounds.map { defaultSound -> AudioFile in
                                    var result = defaultSound
                                    if result.id == sound.id {
                                        result.selected = true
                                    } else {
                                        result.selected = false
                                    }
                                    return result
                                }
                            } label: {
                                Text(sound.name)
                                    .customFont(.medium, .medium, color: DEFAULT_SOUNDS_TEXT_COLOR)
                            }
                        }
                        Divider()
                            .background()
                            .tint(LIGHT_TEXT_COLOR.opacity(0.3))
                            .padding(.horizontal, 10)
                    }
                }
            }
            .padding(.top, 16)
            //            .padding(.leading, 90)
        }
    }

    private func showDefaultSoundsButton(isOpen: Bool, geometry: GeometryProxy) -> some View {
        Button {
            self.showDefaultSounds.toggle()
        } label: {
            ZStack {
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(DEFAULT_SOUNDS_COLOR)
                        .frame(
                            width: 10,
                            height: geometry.size.width * self.openDefaultSoundsButtonSizeCoef
                        )
                }
                RoundedRectangle(cornerRadius: 10)
                    .fill(DEFAULT_SOUNDS_COLOR)
                    .frame(
                        width: geometry.size.width * self.openDefaultSoundsButtonSizeCoef,
                        height: geometry.size.width * self.openDefaultSoundsButtonSizeCoef
                    )
                Image(isOpen ? DEFAULT_CLOSE_ICON : MENU_VOICE)
                    .foregroundColor(ACTIVE_MENU_ITEM_COLOR)
                    .frame(
                        width: geometry.size.width * self.openDefaultSoundsIconSizeCoef,
                        height: geometry.size.width * self.openDefaultSoundsIconSizeCoef
                    )
            }
        }
        .frame(
            width: geometry.size.width * self.openDefaultSoundsButtonSizeCoef,
            height: geometry.size.width * self.openDefaultSoundsButtonSizeCoef
        )
    }

    private func recordView(width: CGFloat) -> some View {
        RecordView(
            timeRemaining: AUDIO_MAX_DURATION_IN_SECONDS,
            maxAudioDurationInSeconds: AUDIO_MAX_DURATION_IN_SECONDS,
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
