import SwiftUI

// In-call DTMF keypad; each key press bounces and appends its digit.
struct KeypadView: View {
    @Binding var dialed: String

    private let keys: [[(digit: String, letters: String)]] = [
        [("1", ""), ("2", "ABC"), ("3", "DEF")],
        [("4", "GHI"), ("5", "JKL"), ("6", "MNO")],
        [("7", "PQRS"), ("8", "TUV"), ("9", "WXYZ")],
        [("*", ""), ("0", "+"), ("#", "")],
    ]

    var body: some View {
        Grid(horizontalSpacing: 24, verticalSpacing: 14) {
            ForEach(keys.indices, id: \.self) { row in
                GridRow {
                    ForEach(keys[row], id: \.digit) { key in
                        Button {
                            withAnimation(.snappy) { dialed.append(key.digit) }
                        } label: {
                            VStack(spacing: 0) {
                                Text(key.digit).font(.title)
                                if !key.letters.isEmpty {
                                    Text(key.letters).font(.system(size: 9, weight: .semibold)).kerning(1.5)
                                }
                            }
                            .frame(width: 72, height: 72)
                            .background(.white.opacity(0.18), in: .circle)
                        }
                        .buttonStyle(PressScaleStyle())
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: dialed)
    }
}
