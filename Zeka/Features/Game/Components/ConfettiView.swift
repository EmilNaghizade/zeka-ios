//
//  ConfettiView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI

struct ConfettiView: View {
    @State private var startDate = Date()
    @State private var isFinished = false

    private let duration: TimeInterval = 4

    private let colors: [Color] = [
        .yellow,
        .purple,
        .pink,
        .cyan,
        .green
    ]

    var body: some View {
        TimelineView(
            .animation(paused: isFinished)
        ) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)

            Canvas { context, size in
                if elapsed >= 0 && elapsed < duration {
                    for index in 0..<60 {
                        let delay = Double(index % 10) * 0.06
                        let progress = (elapsed - delay) / 3

                        if progress >= 0 && progress <= 1 {
                            let startX =
                                CGFloat((index * 37) % 100) / 100
                                * size.width

                            let drift =
                                sin(elapsed * 3 + Double(index))
                                * 22

                            let x = startX + CGFloat(drift)
                            let y = -20
                                + CGFloat(progress)
                                * (size.height + 40)

                            let rectangle = CGRect(
                                x: x,
                                y: y,
                                width: 6,
                                height: 12
                            )

                            context.fill(
                                Path(roundedRect: rectangle, cornerRadius: 2),
                                with: .color(
                                    colors[index % colors.count]
                                        .opacity(1 - progress)
                                )
                            )
                        }
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .task {
            startDate = Date()
            isFinished = false

            do {
                try await Task.sleep(for: .seconds(duration))
            } catch {
                return
            }

            isFinished = true
        }
    }
}
