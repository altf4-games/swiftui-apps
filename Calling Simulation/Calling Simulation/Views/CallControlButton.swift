import SwiftUI

// Round in-call button (Mute, Speaker, …). Fills white when switched on.
struct CallControlButton: View {
    let title: String
    let icon: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.35)) { action() }
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .contentTransition(.symbolEffect(.replace))
                    .frame(width: 72, height: 72)
                    .foregroundStyle(isOn ? .black : .white)
                    .background(isOn ? AnyShapeStyle(.white) : AnyShapeStyle(.white.opacity(0.18)), in: .circle)
                Text(title)
                    .font(.footnote)
                    .contentTransition(.opacity)
            }
        }
        .buttonStyle(PressScaleStyle())
    }
}

// Springy shrink on press, shared by the call and keypad buttons.
struct PressScaleStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(isEnabled ? 1 : 0.4)
            .animation(.spring(duration: 0.25, bounce: 0.5), value: configuration.isPressed)
    }
}
