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

    func startRecord() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let fileName = path.appendingPathComponent(AUDIO_FILE_NAME)
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
        if self.audioRecorder.isRecording {
            self.audioRecorder.stop()
        }
    }

    func startPlay(audioUrl: URL,  speedValue: Float, pitchValue: Float, onComplete: @escaping () -> Void) {
        do {
            let file = try AVAudioFile(forReading: audioUrl)

            self.audioPlayer = AVAudioPlayerNode()

            self.pitchControl.pitch = pitchValue
            self.speedControl.rate = speedValue

            self.engine.attach(self.audioPlayer)
            self.engine.attach(self.pitchControl)
            self.engine.attach(self.speedControl)

            self.engine.connect(self.audioPlayer, to: self.speedControl, format: nil)
            self.engine.connect(self.speedControl, to: self.pitchControl, format: nil)
            self.engine.connect(self.pitchControl, to: engine.mainMixerNode, format: nil)

            self.audioPlayer.scheduleFile(file, at: nil) {
                DispatchQueue.main.async {
                    onComplete()
//                    self.saveAudioWithParams(file: file)
                }
            }
            try self.engine.start()
            self.audioPlayer.play()
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
            self.audioPlayer.stop()
        }
    }

//    func saveAudioWithParams(file: AVAudioFile) {
//
//        do {
//            // The maximum number of frames the engine renders in any single render call.
//            let maxFrames: AVAudioFrameCount = 4096
//            try self.engine.enableManualRenderingMode(
//                .offline,
//                format: AVAudioFormat(settings: file.fileFormat.settings)!,
//                maximumFrameCount: maxFrames
//            )
//        } catch {
//            fatalError("Enabling manual rendering mode failed: \(error).")
//        }
////        file.fileFormat.
//
//        // The output buffer to which the engine renders the processed data.
//        let buffer = AVAudioPCMBuffer(
//            pcmFormat: engine.manualRenderingFormat,
//            frameCapacity: engine.manualRenderingMaximumFrameCount
//        )!
//
//        let outputFile: AVAudioFile
//        do {
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let outputURL = documentsURL.appendingPathComponent("talking_images_record-p.m4a")
//
//            outputFile = try AVAudioFile(
//                forWriting: outputURL,
//                settings: file.fileFormat.settings
//            )
//        } catch {
//            fatalError("Unable to open output audio file: \(error).")
//        }
//        while self.engine.manualRenderingSampleTime < file.length {
//            do {
//                let frameCount = file.length - self.engine.manualRenderingSampleTime
//                let framesToRender = min(AVAudioFrameCount(frameCount), buffer.frameCapacity)
//
//                let status = try self.engine.renderOffline(framesToRender, to: buffer)
//
//                switch status {
//
//                case .success:
//                    // The data rendered successfully. Write it to the output file.
//                    try outputFile.write(from: buffer)
//
//                case .insufficientDataFromInputNode:
//                    // Applicable only when using the input node as one of the sources.
//                    break
//
//                case .cannotDoInCurrentContext:
//                    // The engine couldn't render in the current render call.
//                    // Retry in the next iteration.
//                    break
//
//                case .error:
//                    // An error occurred while rendering the audio.
//                    fatalError("The manual rendering failed.")
//                }
//            } catch {
//                fatalError("The manual rendering failed: \(error).")
//            }
//        }
//    }

}
