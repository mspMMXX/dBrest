//
//  CircularCountdownView.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI

struct CircularTimerView: View {
    @ObservedObject var countdownTimer: CountdownTimer
    @State private var isPaused = false

    var body: some View {
        VStack {
            ZStack {
                // Hintergrundkreis
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 30)
                
                // Fortschrittskreis (grün = Mixphase, rot = Pause)
                Circle()
                    .trim(from: 0.0, to: countdownTimer.progress)
                    .stroke(
                        countdownTimer.isMixing ? .green : .red,
                        style: StrokeStyle(lineWidth: 30, lineCap: .round)
                    )
                    .rotationEffect(.degrees(90))
                
                // Timer-Anzeige im Kreis
                VStack {
                    Text(countdownTimer.phaseName)
                    Text("\(countdownTimer.remainingTime / 60) min.")
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
            
            // Steuerungsbuttons
            HStack {
                Button {
                    isPaused.toggle()
                    isPaused ? countdownTimer.pauseTimer() : countdownTimer.resumeTimer()
                } label: {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
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
