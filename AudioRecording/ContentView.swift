//
//  ContentView.swift
//  AudioRecording
//
//  Created by Ilyasa Azmi on 06/11/19.
//  Copyright © 2019 Ilyasa Azmi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        NavigationView {
            VStack {
                RecordingList(audioRecorder: audioRecorder)
                Image(systemName: "waveform.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                if audioRecorder.recording == false {
                    Button(action: {self.audioRecorder.startRecording()}) {
                        Image(systemName: "circle.fill")
                        .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                        .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                } else {
                    Button(action: {self.audioRecorder.stopRecording()}) {
                        Image(systemName: "stop.fill")
                        .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                        .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                }
            }
        .navigationBarTitle("Voice Recorder")
        .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
