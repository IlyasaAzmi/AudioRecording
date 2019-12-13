//
//  TimerCount.swift
//  AudioRecording
//
//  Created by Ilyasa Azmi on 13/11/19.
//  Copyright © 2019 Ilyasa Azmi. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// 1.
class TimerCount: ObservableObject {
    
    // 2.
    @Published var counter: Double = 0.0
    
    var timer = Timer()
    
    // 3.
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.counter += 0.5
        }
    }
    
    // 4.
    func stop() {
        timer.invalidate()
    }
    
    // 5.
    func reset() {
        counter = 0
        timer.invalidate()
    }
}
