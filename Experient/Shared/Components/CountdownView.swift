//
//  CountdownView.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import SwiftUI
import Combine

struct CountdownView: View {
    let targetDate: Date
    @State private var now: Date = Date()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var remainingTime: TimeInterval {
        max(targetDate.timeIntervalSince(now), 0)
    }

    var body: some View {
        Text(timeString(from: remainingTime))
        .font(.largeTitle)
        .onReceive(timer) { input in
            now = input
        }
    }

    func timeString(from interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: interval) ?? "00:00:00"
    }
}

#Preview {
    CountdownView(targetDate: Date().addingTimeInterval(3600))
}
