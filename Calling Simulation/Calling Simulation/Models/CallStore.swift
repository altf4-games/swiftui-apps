import SwiftUI

enum CallDirection {
    case outgoing, incoming
}

enum CallOutcome {
    case completed, missed, cancelled
}

// The call currently on screen.
struct ActiveCall: Identifiable {
    let id = UUID()
    let contact: Contact
    let direction: CallDirection
    // The row the call screen zooms out of.
    var sourceID: UUID?
}

// A finished call shown on the Recents tab.
struct CallLogEntry: Identifiable {
    let id = UUID()
    let contact: Contact
    let direction: CallDirection
    let outcome: CallOutcome
    let duration: Int
    let date: Date
}

@Observable final class CallStore {
    var activeCall: ActiveCall?
    var recents: [CallLogEntry] = []

    var missedCount: Int {
        recents.filter { $0.outcome == .missed }.count
    }

    func startCall(to contact: Contact, from sourceID: UUID? = nil) {
        activeCall = ActiveCall(contact: contact, direction: .outgoing, sourceID: sourceID)
    }

    func simulateIncomingCall() {
        guard let contact = Contact.samples.randomElement() else { return }
        activeCall = ActiveCall(contact: contact, direction: .incoming)
    }

    func log(_ call: ActiveCall, outcome: CallOutcome, duration: Int) {
        let entry = CallLogEntry(contact: call.contact, direction: call.direction,
                                 outcome: outcome, duration: duration, date: .now)
        withAnimation(.spring) {
            recents.insert(entry, at: 0)
        }
    }

    func clearRecents() {
        withAnimation { recents.removeAll() }
    }
}

extension Int {
    // 75 -> "01:15"
    var callDuration: String {
        String(format: "%02d:%02d", self / 60, self % 60)
    }
}
