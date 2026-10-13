import SwiftUI

struct AvatarView: View {
    let contact: Contact
    var size: CGFloat = 44

    var body: some View {
        Circle()
            .fill(contact.tint.gradient)
            .overlay {
                Text(contact.initials)
                    .font(.system(size: size * 0.38, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .frame(width: size, height: size)
    }
}

// Expanding rings that ripple out from the avatar while a call is ringing.
struct PulsingRings: View {
    var color: Color = .white
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .stroke(color.opacity(0.7), lineWidth: 2)
                    .scaleEffect(animate ? 1.9 : 1)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 2.1)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.7),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}

#Preview {
    ZStack {
        Color.indigo.ignoresSafeArea()
        PulsingRings().frame(width: 140, height: 140)
        AvatarView(contact: Contact.samples[0], size: 140)
    }
}
