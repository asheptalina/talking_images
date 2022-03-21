import SwiftUI

struct VoiceView: View {
    
    @EnvironmentObject var voiceViewModel: VoiceViewModel
    
    let recordButtonSize: CGFloat = 90
    
    var body: some View {
        if voiceViewModel.isPlaying {
            self.playRecordView(isPlaying: true)
        } else if voiceViewModel.isRecording {
            Text("Recording")
        } else if voiceViewModel.audioUrl == nil {
            self.startRecordView()
        } else if voiceViewModel.audioUrl != nil {
            self.playRecordView(isPlaying: false)
        }
    }
    
    private func startRecordView() -> some View {
        VStack {
            ZStack {
                HStack {
                    Text("0:00")
                        .customFont(.semiBold, .medium)
                        .foregroundColor(TEXT_COLOR)
                        .padding(.horizontal, 64)
                    Spacer()
                }
                self.recordButton()
            }
            Text("hold to record")
                .customFont(.semiBold, .small)
                .foregroundColor(GREY_TEXT_COLOR)
        }
    }
    
    private func playRecordView(isPlaying: Bool) -> some View {
        return VStack {
            ZStack {
                HStack {
                    Image("record_again_icon")
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .padding(.horizontal, 64)
                    Spacer()
                }
                Image("play_icon")
                    .scaledToFit()
                    .frame(width: 64, height: 64)
            }
            HStack {
                Text("Speed")
                    .customFont(.semiBold, .medium)
                    .foregroundColor(TEXT_COLOR)
                Slider(
                    value: self.$voiceViewModel.speedValue, 
                    in: -50...50
                )
            }
            
            HStack { 
                Text("Pitch")
                    .customFont(.semiBold, .medium)
                    .foregroundColor(TEXT_COLOR)
                Slider(
                    value: self.$voiceViewModel.pitchValue, 
                    in: -50...50
                )
            }
        }
    }
    
    private func recordButton() -> some View {
        return ZStack {
            Circle()
                .strokeBorder(RECORD_BUTTON_COLOR.opacity(0.2), lineWidth: 4)
                .background(Circle().fill(BACKGROUND_COLOR))
                .frame(width: recordButtonSize, height: recordButtonSize)
            Circle()
                .foregroundColor(RECORD_BUTTON_COLOR)
                .frame(width: recordButtonSize - 24, height: recordButtonSize - 24)
        }
    }
    
}

struct VoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView()
    }
}
