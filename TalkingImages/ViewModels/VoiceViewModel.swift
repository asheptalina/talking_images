import Foundation
import AVFoundation

//https://www.hackingwithswift.com/example-code/media/how-to-control-the-pitch-and-speed-of-audio-using-avaudioengine
class VoiceViewModel: NSObject, ObservableObject {

    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayerNode!

    var audioUrl: URL?

    var indexOfPlayer = 0

    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var timerCount: Timer?

    @Published var speedValue: Float = 1.0
    @Published var pitchValue: Float = 0

    let recordingDuration = 30

    var playingURL: URL?

    private let engine = AVAudioEngine()
    private let speedControl = AVAudioUnitVarispeed()
    private let pitchControl = AVAudioUnitTimePitch()

    override init() {
        super.init()
    }

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
        self.audioUrl = fileName.absoluteURL

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

        } catch {
            print("Failed to Setup the Recording")
        }
    }

    func stopRecording() {
        if audioRecorder.isRecording {
            audioRecorder.stop()
        }

        isRecording = false

//        timerCount!.invalidate()
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
            let file = try AVAudioFile(forReading: playingURL)

            // 2: create the audio player
            self.audioPlayer = AVAudioPlayerNode()

            self.pitchControl.pitch = self.pitchValue
            self.speedControl.rate = self.speedValue

            // 3: connect the components to our playback engine
            engine.attach(audioPlayer)
            engine.attach(pitchControl)
            engine.attach(speedControl)

            // 4: arrange the parts so that output from one is input to another
            engine.connect(audioPlayer, to: speedControl, format: nil)
            engine.connect(speedControl, to: pitchControl, format: nil)
            engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

            // 5: prepare the player to play its file from the beginning
            audioPlayer.scheduleFile(file, at: nil) {
                DispatchQueue.main.async {
                    self.isPlaying = false
                }
            }
            audioPlayer.scheduleFile(file, at: nil)

            // 6: start the engine and player
            try engine.start()
            audioPlayer.play()

//            audioPlayer = try AVAudioPlayer(contentsOf: playingURL)
//            audioPlayer.delegate = self
//            audioPlayer.prepareToPlay()
//            audioPlayer.rate = self.speedValue
//            audioPlayer.play()

            self.isPlaying = true
        } catch {
            print("Playing Failed")
        }

    }

    func pausePlaying() {
        if self.audioPlayer.isPlaying {
            self.audioPlayer.pause() // TODO: rememer the time
        }
    }

    func stopPlaying() {
        if self.audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        self.isPlaying = false
    }

}
