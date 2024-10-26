//
//  ThickProgressView.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 26.10.2024.
//

import SwiftUI

struct ThickProgressView: View {
    @State var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let iconWidth: CGFloat = 20
            let progressBarWidth = progressWidth(totalWidth: totalWidth)
            let iconOffsetX = min(max(progressBarWidth - iconWidth, 0), totalWidth - iconWidth)

            ZStack(alignment: .leading) {
                // Background Bar
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)

                // Foreground Progress Bar
                RoundedRectangle(cornerRadius: 10)
                    .fill(progress >= 0.6 ? .green : .red)
                    .frame(width: progressBarWidth, height: 20)

                // Conditional Icon overlapping the progress bar
                Image(systemName: progress >= 0.6 ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: iconWidth, height: 20)
                    .offset(x: iconOffsetX)
            }
            .animation(.easeInOut(duration: 0.5), value: progress)
        }
        .frame(height: 20)
    }

    private func progressWidth(totalWidth: CGFloat) -> CGFloat {
        // Clamp progress between 0.0 and 1.0
        let clampedProgress = min(max(progress, 0.0), 1.0)
        return clampedProgress * totalWidth
    }
}
