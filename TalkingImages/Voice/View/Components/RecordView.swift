import SwiftUI

struct RecordView: View {

    @State var timeRemaining: Int
    var maxAudioDurationInSeconds: Int
    var width: CGFloat
    var onStartRecord: () -> Void
    var onEndRecord: () -> Void

    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // UI constants
    private let recordButtonSizeCoef = 0.19
    
    var body: some View {
        self.startRecordView()
    }

    private func startRecordView() -> some View {
        let minutes = self.timeRemaining / 60
        let seconds = self.timeRemaining - minutes * 60
        return VStack {
            ZStack {
                HStack {
                    Text(String(format: "%d:%@%d", minutes, seconds > 9 ? "" : "0", seconds))
                        .customFont(.semiBold, .medium, color: TEXT_COLOR)
                        .padding(.horizontal, 64)
                        .onReceive(timer) { _ in
                            if self.timeRemaining > 0 {
                                self.timeRemaining -= 1
                            } else {
                                self.stopTimer()
                            }
                        }
                    Spacer()
                }
                self.recordButton(size: self.width * self.recordButtonSizeCoef)
            }
            Text("hold to record")
                .customFont(.semiBold, .small, color: GREY_TEXT_COLOR)
        }.onAppear {
            self.timer.upstream.connect().cancel()
        }
    }

    private func recordButton(size: CGFloat) -> some View {
        let recordedPercent = CGFloat(self.maxAudioDurationInSeconds - self.timeRemaining)
            / CGFloat(self.maxAudioDurationInSeconds)
        return Button(action: {
            print("tt")
            self.stopTimer()
        }, label: {
            ZStack {
                Circle()
                    .strokeBorder(RECORD_BUTTON_COLOR.opacity(0.2), lineWidth: 4)
                    .frame(width: size, height: size)
                Circle()
                    .foregroundColor(RECORD_BUTTON_COLOR)
                    .frame(width: size - 24, height: size - 24)
                if recordedPercent > 0 {
                    Circle()
                        .trim(from: 0, to: recordedPercent)
                        .stroke(RECORD_BUTTON_COLOR, style: StrokeStyle(lineWidth: 8.0, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: size, height: size)
                }
            }
        })
            .buttonStyle(.plain)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 1)
                    .onEnded { _ in
                        print("ll")
                        self.startTimer()
                    }
            )
    }

    private func startTimer() {
        self.timeRemaining = self.maxAudioDurationInSeconds
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        self.onStartRecord()
    }

    private func stopTimer() {
        self.timer.upstream.connect().cancel()
        self.onEndRecord()
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(timeRemaining: 30, maxAudioDurationInSeconds: 30, width: 480, onStartRecord: {}, onEndRecord: {})
    }
}
