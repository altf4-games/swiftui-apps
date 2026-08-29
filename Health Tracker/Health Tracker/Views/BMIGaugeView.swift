//
//  BMIGaugeView.swift
//  Health Tracker
//

import SwiftUI

struct BMIGaugeView: View {
    let bmi: Double

    private var category: BMICategory { BMICategory(bmi: bmi) }
    private var fraction: Double { BMI.gaugeFraction(bmi) }

    private let segments: [BMICategory] = [.underweight, .normal, .overweight, .obese]

    var body: some View {
        ZStack {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let lineWidth = size * 0.09

                ZStack {
                    ForEach(Array(segments.enumerated()), id: \.offset) { index, segment in
                        let start = segment.rangeStart
                        let end = index + 1 < segments.count ? segments[index + 1].rangeStart : 1.0
                        Circle()
                            .trim(from: 0.5 + start * 0.75, to: 0.5 + end * 0.75)
                            .stroke(segment.color.opacity(0.9), style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
                            .rotationEffect(.degrees(-90))
                    }

                    // Indicator dot at current BMI position along the arc
                    Circle()
                        .fill(Color.white)
                        .frame(width: lineWidth * 0.7, height: lineWidth * 0.7)
                        .shadow(color: .black.opacity(0.25), radius: 3, y: 1)
                        .offset(indicatorOffset(radius: (size - lineWidth) / 2, fraction: fraction))
                }
                .frame(width: size, height: size)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }

            VStack(spacing: 4) {
                Text(bmi > 0 ? String(format: "%.1f", bmi) : "—")
                    .font(.system(size: 44, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                Text(bmi > 0 ? category.label : "No data")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(bmi > 0 ? category.color : .secondary)
            }
            .padding(.top, 8)
        }
    }

    /// Computes the offset of the indicator dot along a 270° arc starting at the bottom-left (135°)
    /// and sweeping clockwise to the bottom-right (45°), matching the trimmed circle segments above.
    private func indicatorOffset(radius: CGFloat, fraction: Double) -> CGSize {
        // Segments are trimmed on a circle starting at trim 0.5, sweeping 0.75 of the full
        // circle, then rotated -90°; mirror that math here to place the dot on the same arc.
        let trimStart = 0.5
        let sweep = 0.75
        let trimValue = trimStart + fraction * sweep
        let degrees = trimValue * 360.0 - 90.0
        let radians = degrees * .pi / 180
        return CGSize(width: radius * cos(radians), height: radius * sin(radians))
    }
}

#Preview {
    VStack(spacing: 40) {
        BMIGaugeView(bmi: 22.4)
            .frame(width: 240, height: 240)
        BMIGaugeView(bmi: 31.2)
            .frame(width: 240, height: 240)
    }
    .padding()
}
