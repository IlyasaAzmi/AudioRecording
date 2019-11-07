//
//  AudioRecorder.swift
//  AudioRecording
//
//  Created by Ilyasa Azmi on 06/11/19.
//  Copyright © 2019 Ilyasa Azmi. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    
    @Published var circleProgress : CGFloat = 0.0
    
    override init() {
        super.init()
        fetchRecordings()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recordings = [Recording]()
    
    var recording  = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let audioFileName = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.record()
            
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        
        fetchRecordings()
    }
    
    func fetchRecordings() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documemtDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documemtDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            print(url)
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted")
            }
        }
        
        fetchRecordings()
    }
    
//    func startLoading() {
//        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//            withAnimation() {
//                self.circleProgress += 0.01
//                if self.circleProgress >= 1.0 {
//                    timer.invalidate()
//                }
//            }
//        }
//    }
    
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatteer = DateFormatter()
        dateFormatteer.dateFormat = format
        return dateFormatteer.string(from: self)
    }
}
