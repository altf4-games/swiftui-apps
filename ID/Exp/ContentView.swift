import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack {
                    IDCardView()

                    NavigationLink {
                        QRView()
                    } label: {
                        Text("View QR Code")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct IDCardView: View {
    var body: some View {
        VStack(spacing: 0) {

            // Header
            VStack(spacing: 4) {
                Text("SOMAIYA VIDYAVIHAR UNIVERSITY")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("K. J. Somaiya College of Engineering")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)

            VStack(spacing: 18) {

                // Photo
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(.gray)
                    )

                Text("XYZ")
                    .font(.title2.bold())

                Text("Student")
                    .foregroundStyle(.secondary)

                Divider()

                VStack(spacing: 12) {
                    InfoRow(title: "Roll No", value: "123")
                    InfoRow(title: "Programme", value: "B.Tech Computer Engineering")
                    InfoRow(title: "Year", value: "Second Year")
                    InfoRow(title: "Academic Year", value: "2026–27")
                }

                Divider()

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 110, height: 110)
                    .overlay(
                        Image(systemName: "qrcode")
                            .resizable()
                            .scaledToFit()
                            .padding(18)
                    )

                Text("Student ID")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .frame(width: 340)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.18), radius: 12, y: 8)
        .padding()
    }
}

struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct QRView: View {
    var body: some View {
        VStack(spacing: 25) {

            Image(systemName: "qrcode")
                .resizable()
                .scaledToFit()
                .frame(width: 250)

            Text("Scan for Verification")
                .font(.headline)
        }
        .padding()
        .navigationTitle("QR Code")
    }
}

#Preview {
    ContentView()
}
