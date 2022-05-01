import Foundation
import AVFoundation
import AVFAudio

class VoiceService {
    private var audioRecorder: AVAudioRecorder!

    private var audioPlayer: AVAudioPlayerNode!

    private let engine = AVAudioEngine()
    private let speedControl = AVAudioUnitVarispeed()
    private let pitchControl = AVAudioUnitTimePitch()

    private var audioUrl: URL?

    private let audioFileName = "talking_images_record.m4a"

    func startRecord() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let fileName = path.appendingPathComponent(self.audioFileName)
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
        } catch {
            print("Failed to Setup the Recording")
        }
    }

    func stopRecord() {
        if audioRecorder.isRecording {
            audioRecorder.stop()
        }
    }

    func startPlay(speedValue: Float, pitchValue: Float, onComplete: @escaping () -> Void) {
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

            self.audioPlayer = AVAudioPlayerNode()

            self.pitchControl.pitch = pitchValue
            self.speedControl.rate = speedValue

            engine.attach(audioPlayer)
            engine.attach(pitchControl)
            engine.attach(speedControl)

            engine.connect(audioPlayer, to: speedControl, format: nil)
            engine.connect(speedControl, to: pitchControl, format: nil)
            engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

            audioPlayer.scheduleFile(file, at: nil) {
                DispatchQueue.main.async {
                    onComplete()
                }
            }
            audioPlayer.scheduleFile(file, at: nil)

            try engine.start()
            audioPlayer.play()
        } catch {
            print("Playing Failed")
        }
    }

    func pausePlay() {
        if self.audioPlayer.isPlaying {
            self.audioPlayer.pause() // TODO: rememer the time
        }
    }

    func stopPlay() {
        if self.audioPlayer.isPlaying {
            audioPlayer.stop()
        }
    }

}
