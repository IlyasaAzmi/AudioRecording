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

    @State var circleProgress : CGFloat = 0.0
    
    @State private var timer: Timer?
    @State var power = 0.0
    @State var randomizeTimer: Timer!
    
    var body: some View {
        NavigationView {
            VStack {
                RecordingList(audioRecorder: audioRecorder)
                Spacer()
                
                VStack {
                    SiriWaveView()
                        .power(power: power)
                        .colors(colors: [
                            Color(red: (182 / 255), green: (41 / 255), blue: (230 / 255)),
                            Color(red: (39 / 255), green: (84 / 255), blue: (232 / 255)),
                            Color(red: (39 / 255), green: (203 / 255), blue: (232 / 255))
                        ])
                        .frame(height: 100, alignment: .leading)
//                        .background(Color(red: (28 / 255), green: (44 / 255), blue: (61 / 255)))
                        .background(Color(.clear))
//                    Button(action: randomizeTimer == nil ? randomize : stop, label: {
//                        Text(randomizeTimer == nil ? "Randomize!" : "Stop")
//                    })
                        .padding(.top, 50)
                }
                
                if audioRecorder.recording == false {
                    Button(action: {self.startLoading()}) {
                        ZStack {
                            Circle()
                                .fill(Color(#colorLiteral(red: 0.2235294118, green: 0.1725490196, blue: 0.5098039216, alpha: 1)))
                                .frame(width: 100)
                            Circle()
                                .fill(Color(.white))
                                .frame(width: 85)
                            Circle()
                                .fill(Color(#colorLiteral(red: 0.2235294118, green: 0.1725490196, blue: 0.5098039216, alpha: 1)))
                                .frame(width: 75)
                        }
                    }
                } else {
                    Button(action: {self.stopLoading()}) {
                        ZStack {
                            Circle()
                            .trim(from: 0.0, to: circleProgress)
                            .stroke(Color(#colorLiteral(red: 87/255, green: 189/255, blue: 115/255, alpha: 100/100)), lineWidth: 10)
                            .frame(width: 100, height: 100)
                            .rotationEffect(Angle(degrees: -90))
                            Circle()
                                .fill(Color(#colorLiteral(red: 0.2235294118, green: 0.1725490196, blue: 0.5098039216, alpha: 1)))
                                .frame(width: 100)
                            Circle()
                                .fill(Color(.white))
                                .frame(width: 85)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(#colorLiteral(red: 0.2235294118, green: 0.1725490196, blue: 0.5098039216, alpha: 1)))
                            .frame(width: 40, height: 40)
                        }
                    }
                }
            }
        .navigationBarTitle("Voice Recorder")
        .navigationBarItems(trailing: EditButton())
        }
    }
    
    func startLoading() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation() {
                print("pp", self.circleProgress)
                self.circleProgress += 0.01
            }
        }
        randomize()
        self.audioRecorder.startRecording()
    }
    
    func stopLoading() {
        timer?.invalidate()
        
        circleProgress = 0.0
        
        stop()
        self.audioRecorder.stopRecording()
    }
    
    func randomize() {

        randomizeTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in

            let randomPower = Double.random(in: 0 ... 1.0)
            self.power = self.power == 0.0 ? randomPower : 0.0
            print(randomPower)

        })

    }

    func stop() {

        randomizeTimer.invalidate()
        randomizeTimer = nil

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
