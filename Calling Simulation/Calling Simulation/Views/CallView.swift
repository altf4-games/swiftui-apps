import SwiftUI

enum CallPhase {
    case dialing, ringing, incoming, connected, ended
}

// Screen 3: the in-call screen. Every phase change is animated.
struct CallView: View {
    @Environment(CallStore.self) private var store
    let call: ActiveCall

    @State private var phase: CallPhase
    @State private var elapsed = 0
    @State private var isMuted = false
    @State private var isSpeakerOn = false
    @State private var isOnHold = false
    @State private var showKeypad = false
    @State private var dialed = ""
    @State private var shiftBackground = false
    // Lets the red end button glide from the incoming layout to the in-call layout.
    @Namespace private var controls

    init(call: ActiveCall) {
        self.call = call
        _phase = State(initialValue: call.direction == .incoming ? .incoming : .dialing)
    }

    private var statusText: String {
        switch phase {
        case .dialing: "Calling…"
        case .ringing: "Ringing…"
        case .incoming: "Incoming call"
        case .connected: isOnHold ? "On Hold" : elapsed.callDuration
        case .ended: "Call Ended"
        }
    }

    private var isRinging: Bool {
        phase == .dialing || phase == .ringing || phase == .incoming
    }

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                header
                    .padding(.top, 60)

                Spacer()

                bottomArea
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 32)
        }
        .foregroundStyle(.white)
        // Light status bar over the coloured call background.
        .preferredColorScheme(.dark)
        .sensoryFeedback(.impact(weight: .medium), trigger: phase)
        .task { await runOutgoingSequence() }
        .task(id: phase) { await runTimer() }
    }

    // MARK: - Background

    private var background: some View {
        LinearGradient(
            colors: [call.contact.tint, call.contact.tint.mix(with: .black, by: 0.6)],
            startPoint: shiftBackground ? .topLeading : .top,
            endPoint: shiftBackground ? .bottomTrailing : .bottom
        )
        .hueRotation(.degrees(shiftBackground ? 25 : 0))
        .overlay(Color.black.opacity(phase == .ended ? 0.55 : 0))
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever()) {
                shiftBackground = true
            }
        }
    }

    // MARK: - Header (avatar, name, status)

    private var header: some View {
        VStack(spacing: 16) {
            ZStack {
                if isRinging {
                    PulsingRings()
                        .transition(.opacity)
                }
                AvatarView(contact: call.contact, size: phase == .connected ? 96 : 130)
                    .overlay(Circle().stroke(.white.opacity(0.8), lineWidth: 3))
                    .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
                    .scaleEffect(phase == .ended ? 0.8 : 1)
                    .opacity(phase == .ended ? 0.6 : 1)
            }
            .frame(width: 130, height: 130)
            .padding(.bottom, 12)

            Text(call.contact.name)
                .font(.system(.largeTitle, design: .rounded, weight: .semibold))

            Text(statusText)
                .font(.title3.monospacedDigit())
                .opacity(0.85)
                .contentTransition(.numericText())
                .animation(.snappy, value: statusText)

            if showKeypad && !dialed.isEmpty {
                Text(dialed)
                    .font(.title2.monospacedDigit())
                    .transition(.scale.combined(with: .opacity))
            }

            if phase == .incoming {
                Label("Mobile · \(call.contact.phone)", systemImage: "iphone.gen3.radiowaves.left.and.right")
                    .font(.footnote)
                    .opacity(0.7)
                    .transition(.opacity)
            }
        }
    }

    // MARK: - Bottom controls

    @ViewBuilder
    private var bottomArea: some View {
        switch phase {
        case .incoming:
            incomingActions
                .transition(.move(edge: .bottom).combined(with: .opacity))
        case .dialing, .ringing, .connected:
            VStack(spacing: 36) {
                if showKeypad {
                    KeypadView(dialed: $dialed)
                        .transition(.scale(scale: 0.85).combined(with: .opacity))
                } else {
                    controlGrid
                        .transition(.scale(scale: 0.85).combined(with: .opacity))
                }
                endButton
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        case .ended:
            EmptyView()
        }
    }

    private var incomingActions: some View {
        HStack {
            VStack(spacing: 8) {
                endButton
                Text("Decline").font(.footnote)
            }
            Spacer()
            VStack(spacing: 8) {
                Button {
                    withAnimation(.spring(duration: 0.6, bounce: 0.3)) { phase = .connected }
                } label: {
                    Image(systemName: "phone.fill")
                        .font(.title)
                        .frame(width: 76, height: 76)
                        .background(.green, in: .circle)
                        // Continuous wiggle to draw attention to the answer button.
                        .phaseAnimator([0.0, -14, 14, -10, 10, 0, 0, 0]) { content, angle in
                            content.rotationEffect(.degrees(angle))
                        } animation: { _ in .linear(duration: 0.09) }
                }
                .accessibilityLabel("Accept")
                Text("Accept").font(.footnote)
            }
        }
        .padding(.horizontal, 16)
    }

    private var controlGrid: some View {
        Grid(horizontalSpacing: 28, verticalSpacing: 24) {
            GridRow {
                CallControlButton(title: isMuted ? "Unmute" : "Mute",
                                  icon: isMuted ? "mic.slash.fill" : "mic.fill",
                                  isOn: isMuted) { isMuted.toggle() }
                CallControlButton(title: "Keypad", icon: "circle.grid.3x3.fill", isOn: false) {
                    showKeypad = true
                }
                CallControlButton(title: "Speaker",
                                  icon: isSpeakerOn ? "speaker.wave.3.fill" : "speaker.fill",
                                  isOn: isSpeakerOn) { isSpeakerOn.toggle() }
            }
            GridRow {
                CallControlButton(title: "Add", icon: "person.badge.plus", isOn: false) {}
                CallControlButton(title: isOnHold ? "Resume" : "Hold",
                                  icon: isOnHold ? "play.fill" : "pause.fill",
                                  isOn: isOnHold) { isOnHold.toggle() }
                    .disabled(phase != .connected)
                CallControlButton(title: "Video", icon: "video.fill", isOn: false) {}
            }
        }
        .disabled(phase == .ended)
    }

    private var endButton: some View {
        HStack {
            if showKeypad {
                // Keeps the end button centred while the "Hide" button sits beside it.
                Color.clear.frame(width: 60)
            }
            Button(action: endCall) {
                Image(systemName: "phone.down.fill")
                    .font(.title)
                    .frame(width: 76, height: 76)
                    .background(.red, in: .circle)
            }
            .matchedGeometryEffect(id: "end", in: controls)
            .accessibilityLabel(phase == .incoming ? "Decline" : "End Call")
            if showKeypad {
                Button("Hide") {
                    withAnimation(.spring) { showKeypad = false; dialed = "" }
                }
                .frame(width: 60)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
    }

    // MARK: - Call lifecycle

    // Outgoing calls: "Calling…" → "Ringing…" → connected.
    private func runOutgoingSequence() async {
        guard call.direction == .outgoing else { return }
        try? await Task.sleep(for: .seconds(1.5))
        guard phase == .dialing else { return }
        withAnimation(.smooth) { phase = .ringing }
        try? await Task.sleep(for: .seconds(2.5))
        guard phase == .ringing else { return }
        withAnimation(.spring(duration: 0.6, bounce: 0.3)) { phase = .connected }
    }

    // Ticks the call timer once a second while connected.
    private func runTimer() async {
        guard phase == .connected else { return }
        while !Task.isCancelled {
            do { try await Task.sleep(for: .seconds(1)) } catch { return }
            if !isOnHold { elapsed += 1 }
        }
    }

    private func endCall() {
        guard phase != .ended else { return }
        let outcome: CallOutcome = switch phase {
        case .connected: .completed
        case .incoming: .missed
        default: .cancelled
        }
        withAnimation(.spring(duration: 0.5)) {
            showKeypad = false
            phase = .ended
        }
        Task {
            try? await Task.sleep(for: .seconds(2))
            store.log(call, outcome: outcome, duration: elapsed)
            store.activeCall = nil
        }
    }
}

#Preview {
    CallView(call: ActiveCall(contact: Contact.samples[1], direction: .incoming))
        .environment(CallStore())
}
