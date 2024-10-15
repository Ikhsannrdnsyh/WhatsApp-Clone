//
//  AudioRecorder.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 15/10/24.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate{
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var isPermissionGranted: Bool!
    
    static let shared = AudioRecorder()
    
    private override init() {
        super.init()
        
        //check permisiion
        checkRecordingPermission()
    }
    
    
    func checkRecordingPermission(){
        if #available(iOS 17.0, *) {
            switch AVAudioApplication.shared.recordPermission {
            case .undetermined:
                AVAudioApplication.requestRecordPermission{ isGranted in
                    self.isPermissionGranted = isGranted
                }
            case .denied:
                self.isPermissionGranted = false
            case .granted:
                self.isPermissionGranted = true
                break
            @unknown default:
                print("Unknown Status")
                break
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupRecordSession(){
        guard isPermissionGranted else { return }
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Error while setup record session ", error.localizedDescription)
        }
    }
    
    func startRecording(fileName: String){
        guard isPermissionGranted else { return }
        
        let audioFileName = getDocumentsUrl().appendingPathComponent(fileName + ".m4a", isDirectory: false)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            print("Error while start recording ", error.localizedDescription)
            finishRecording()
        }
    }
    
    func finishRecording(){
        guard isPermissionGranted else { return }
        
        guard let recorder = audioRecorder else { return }
        
        recorder.stop()
        audioRecorder = nil
    }
    
}
