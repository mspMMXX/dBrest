//
//  CircularCountdownView.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI

struct CircularCountdownView: View {
    
    @ObservedObject var countdownTimer: CountdownTimer
    @State private var isPaused: Bool = false
    
    var body: some View {
        VStack {
            
            ZStack {
                
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 30)
                
                Circle()
                    .trim(from: 0.0, to: countdownTimer.progress)
                    .stroke(countdownTimer.isMixing ? Color.green : Color.red, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .rotationEffect(.degrees(90))
                
                VStack {
                    
                    Text(countdownTimer.mixPhase)
                    
                    Text("\(countdownTimer.remainingTime) Sek.")
                        .font(.largeTitle)
                        .bold()
                }
            }
            .frame(width: 200, height: 200)
            .onAppear {
                countdownTimer.startTimer()
            }
            .onDisappear {
                countdownTimer.timer?.invalidate()
            }
            
            HStack {
                
                Button {
                    if !isPaused {
                        countdownTimer.pauseTimer()
                        isPaused = true
                    } else {
                        countdownTimer.resumeTimer()
                        isPaused = false
                    }
                } label: {
                    if !isPaused {
                        Image(systemName: "pause.fill")
                    } else {
                        Image(systemName: "play.fill")
                    }
                }
                
                Button {
                    countdownTimer.stopTimer()
                } label: {
                    Image(systemName: "stop.fill")
                }
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    CircularCountdownView(countdownTimer: CountdownTimer(mixprofile: Mixprofile(name: "Default", mixDurationInMinutes: 5, pauseDurationInMinutes: 2, cycleCount: 4)))
}

