//
//  CircularCountdownView.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI

struct CircularCountdownView: View {
    
    @State private var progress: CGFloat = 0.0
    @State private var remainingTime: Int = 0
    @State private var timer: Timer?
    @State var mixPhase: String = "Mix"
    
    @Binding var cycleCount: Int
    @Binding var mixDuration: Int
    @Binding var pauseDuration: Int

    var body: some View {
        ZStack {
            //Background-Circle 
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 30)
            
            //Progress-Circle
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .rotationEffect(.degrees(90))
            
            //Text
            VStack {
                Text(mixPhase)
                Text("\(remainingTime)s")
                    .font(.largeTitle)
                    .bold()
            }
        }
        .frame(width: 200, height: 200)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    func startTimer() {
        runCycle(index: 1)
    }

    func runCycle(index: Int) {
        if index > cycleCount {
            mixPhase = "Fertig"
            return
        }

        mixPhase = "Mix"
        remainingTime = mixDuration
        progress = 0
        var elapsed = 0
        let mixStep = 1.0 / CGFloat(mixDuration)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            elapsed += 1
            remainingTime = mixDuration - elapsed
            progress = CGFloat(elapsed) * mixStep

            if elapsed >= mixDuration {
                t.invalidate()
                runPauseCycle(index: index)
            }
        }
    }

    func runPauseCycle(index: Int) {
        mixPhase = "Pause"
        remainingTime = pauseDuration
        progress = 0
        var elapsed = 0
        let pauseStep = 1.0 / CGFloat(pauseDuration)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            elapsed += 1
            remainingTime = pauseDuration - elapsed
            progress = CGFloat(elapsed) * pauseStep
            
            if elapsed >= pauseDuration {
                t.invalidate()
                runCycle(index: index + 1)
            }
        }
    }
}

