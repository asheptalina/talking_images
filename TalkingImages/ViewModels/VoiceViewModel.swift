import Foundation
import AVFoundation

class VoiceViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {

    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!

    var audioUrl: URL?

    var indexOfPlayer = 0

    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var timerCount: Timer?

    @Published var speedValue: CGFloat = 0
    @Published var pitchValue: CGFloat = 0

    let recordingDuration = 30

    var playingURL: URL?

    override init() {
        super.init()
    }

    //    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    //        for i in 0..<recordingsList.count {
    //            if recordingsList[i].fileURL == playingURL {
    //                recordingsList[i].isPlaying = false
    //            }
    //        }
    //    }

    func startRecording() {

        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent("talking_images_record.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true

            //            timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (value) in
            //                self.countSec += 1
            //                self.timer = self.covertSecToMinAndHour(seconds: self.countSec)
            //            })
            //            blinkColor()

        } catch {
            print("Failed to Setup the Recording")
        }
    }

    func stopRecording() {
        audioRecorder.stop()

        isRecording = false

        timerCount!.invalidate()
    }

    func startPlaying() {
        guard let playingURL = self.audioUrl else {
            print("Can't find record")
            return
        }

        let playSession = AVAudioSession.sharedInstance()

        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: playingURL)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()

            self.isPlaying = true
        } catch {
            print("Playing Failed")
        }

    }

    func stopPlaying(url: URL) {
        audioPlayer.stop()
        self.isPlaying = false
    }

}
