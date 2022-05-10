import SwiftUI

struct PlayView: View {

    @EnvironmentObject var store: AppStore

    @State var isPlaying: Bool
    @State var speedValue: Float
    @State var pitchValue: Float

    var width: CGFloat

    var onStartPlaying: () -> Void
    var onStopPlaying: () -> Void
    var onRecordAgain: () -> Void

    // UI constants
    private let recordAgainButtonSizeCoef = 0.17
    private let playButtonSizeCoef = 0.18
    private let pauseButtonSizeCoef = 0.21
    private let horizontalPaddingCoef = 0.08
    private let sliderWidthCoef = 0.65

    private let playedPercent = 0.25 // TODO: remove it

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    self.recordAgainButton()
                    Spacer()
                }
                if self.isPlaying {
                    self.stopPlayingButton()
                } else {
                    self.playButton()
                }
            }
            HStack {
                Text("Speed")
                    .customFont(.semiBold, .small, color: TEXT_COLOR)
                Spacer()
                Slider(
                    value: self.$speedValue,
                    in: 0...2,
                    step: 0.2
                ).tint(TEXT_COLOR)
                    .frame(width: self.width * self.sliderWidthCoef)
            }.padding(.horizontal, self.width * self.horizontalPaddingCoef)

            HStack {
                Text("Pitch")
                    .customFont(.semiBold, .small, color: TEXT_COLOR)
                Spacer()
                Slider(
                    value: self.$pitchValue,
                    in: -500...500,
                    step: 50
                ).tint(TEXT_COLOR)
                    .frame(width: self.width * self.sliderWidthCoef)
            }.padding(.horizontal, self.width * self.horizontalPaddingCoef)
        }.onChange(of: self.speedValue) { newValue in
            self.store.send(.voice(action: .setSpeed(newValue)))
        }.onChange(of: self.speedValue) { newValue in
            self.store.send(.voice(action: .setPitch(newValue)))
        }
    }

    private func recordAgainButton() -> some View {
        Button {
            self.onRecordAgain()
        } label: {
            Image(RECORD_AGAIN_ICON)
                .resizable()
                .scaledToFit()
                .frame(
                    width: self.width * self.recordAgainButtonSizeCoef,
                    height: self.width * self.recordAgainButtonSizeCoef
                )
                .padding(.horizontal, self.width * self.horizontalPaddingCoef)
        }
    }

    private func playButton() -> some View {
        Button {
            self.onStartPlaying()
        } label: {
            Image(PLAY_ICON)
                .resizable()
                .scaledToFit()
                .shadow(color: SHADOW_COLOR.opacity(0.25), radius: 4, x: 2, y: 2)
                .frame(
                    width: self.width * self.pauseButtonSizeCoef,
                    height: self.width * self.pauseButtonSizeCoef
                )
        }
    }

    private func stopPlayingButton() -> some View {
        Button {
            self.onStopPlaying()
        } label: {
            ZStack {
                Image(PAUSE_ICON)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: self.width * self.pauseButtonSizeCoef,
                        height: self.width * self.pauseButtonSizeCoef
                    )
                if playedPercent > 0 {
                    Circle()
                        .trim(from: 0, to: playedPercent)
                        .stroke(PAUSE_BUTTON_COLOR, style: StrokeStyle(lineWidth: 8.0, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(
                            width: self.width * self.pauseButtonSizeCoef,
                            height: self.width * self.pauseButtonSizeCoef
                        )
                }
            }
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            PlayView(
                isPlaying: false,
                speedValue: 35,
                pitchValue: -2,
                width: geometry.size.width,
                onStartPlaying: {},
                onStopPlaying: {},
                onRecordAgain: {}
            )
        }
    }
}
