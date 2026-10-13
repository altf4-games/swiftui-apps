import SwiftUI

struct Contact: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let phone: String
    let tint: Color

    var initials: String {
        name.split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined()
    }

    static let samples: [Contact] = [
        Contact(name: "Aarav Shah", phone: "+91 98200 11223", tint: .indigo),
        Contact(name: "Diya Patel", phone: "+91 98670 44556", tint: .pink),
        Contact(name: "Kabir Mehta", phone: "+91 99300 77889", tint: .teal),
        Contact(name: "Ananya Rao", phone: "+91 98190 22334", tint: .orange),
        Contact(name: "Vihaan Iyer", phone: "+91 97690 55667", tint: .green),
        Contact(name: "Isha Kulkarni", phone: "+91 98330 88990", tint: .purple),
        Contact(name: "Rohan Desai", phone: "+91 90040 12345", tint: .blue),
        Contact(name: "Meera Nair", phone: "+91 98925 67890", tint: .red),
    ]
}
