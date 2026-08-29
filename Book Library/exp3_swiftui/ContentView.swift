//
//  ContentView.swift
//  exp3_swiftui
//
//  Created by kjsce on 11/08/26.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.locale) private var locale
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    let kjsceRed = Color(red: 0.75, green: 0.05, blue: 0.08)
    let lightRed = Color(red: 0.98, green: 0.92, blue: 0.92)

    let books = [
        ("Swift Programming", "Apple Developer", "Programming", "swift"),
        ("Data Structures", "Thomas H. Cormen", "Computer Science", "chart.bar.xaxis"),
        ("Database Management", "Raghu Ramakrishnan", "Database", "cylinder.split.1x2"),
        ("Operating System Concepts", "Silberschatz", "Operating Systems", "desktopcomputer"),
        ("Computer Networks", "Andrew S. Tanenbaum", "Networking", "network"),
        ("Artificial Intelligence", "Stuart Russell", "AI", "brain.head.profile")
    ]
    
    var filteredBooks: [(String, String, String, String)] {
        if searchText.isEmpty {
            return books
        }
        
        return books.filter {
            $0.0.localizedCaseInsensitiveContains(searchText) ||
            $0.1.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // =====================================================
            // HOME
            // =====================================================
            
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Header
                        VStack(alignment: .leading, spacing: 5) {
                            Text("KJSCE Library")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(kjsceRed)
                            
                            Text("Welcome, Student 👋")
                                .font(.title3)
                                .bold()
                            
                            Text("Your digital college library")
                                .foregroundStyle(.secondary)
                        }
                        
                        // Search
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(kjsceRed)
                            
                            TextField(
                                "Search books...",
                                text: $searchText
                            )
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                        )
                        
                        // Student Card
                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack {
                                Image(
                                    systemName:
                                        "person.crop.circle.fill"
                                )
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                
                                VStack(alignment: .leading) {
                                    Text("KJSCE Student")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    
                                    Text("Computer Engineering")
                                        .font(.subheadline)
                                        .foregroundStyle(
                                            .white.opacity(0.85)
                                        )
                                }
                                
                                Spacer()
                            }
                            
                            Divider()
                                .overlay(.white.opacity(0.3))
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Student ID")
                                        .font(.caption)
                                    
                                    Text("CE2026001")
                                        .bold()
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Books Issued")
                                        .font(.caption)
                                    
                                    Text("2 / 5")
                                        .bold()
                                }
                            }
                            .foregroundStyle(.white)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    kjsceRed,
                                    Color.red.opacity(0.65)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                        
                        // Statistics
                        Text("Library Overview")
                            .font(.title2)
                            .bold()
                        
                        HStack(spacing: 12) {
                            statisticCard(
                                number: "2",
                                title: "Borrowed",
                                icon: "book.fill"
                            )
                            
                            statisticCard(
                                number: "1",
                                title: "Due Soon",
                                icon: "clock.fill"
                            )
                            
                            statisticCard(
                                number: "5",
                                title: "Available",
                                icon: "checkmark.circle.fill"
                            )
                        }
                        
                        // Quick Actions
                        Text("Quick Actions")
                            .font(.title2)
                            .bold()
                        
                        HStack(spacing: 12) {
                            
                            Button {
                                selectedTab = 1
                            } label: {
                                quickAction(
                                    title: "Browse Books",
                                    icon: "books.vertical.fill"
                                )
                            }
                            .buttonStyle(.plain)
                            
                            Button {
                                selectedTab = 2
                            } label: {
                                quickAction(
                                    title: "My Books",
                                    icon: "book.closed.fill"
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // Due Soon
                        VStack(alignment: .leading, spacing: 10) {
                            Label(
                                "Due Soon",
                                systemImage:
                                    "exclamationmark.triangle.fill"
                            )
                            .font(.headline)
                            .foregroundStyle(.orange)
                            
                            Text("Data Structures")
                                .font(.headline)
                            
                            Text(
                                Date.now.addingTimeInterval(
                                    3 * 86400
                                )
                                .formatted(
                                    .dateTime
                                        .day()
                                        .month()
                                        .year()
                                        .locale(locale)
                                )
                            )
                            .foregroundStyle(.secondary)
                            
                            Text("Return within 3 days")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        .padding()
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    Color.orange.opacity(0.1)
                                )
                        )
                        
                        // Library Hours
                        VStack(alignment: .leading, spacing: 10) {
                            Label(
                                "KJSCE Library Hours",
                                systemImage: "clock.fill"
                            )
                            .font(.headline)
                            .foregroundStyle(kjsceRed)
                            
                            Text(
                                "Monday – Friday    8:00 AM – 8:00 PM"
                            )
                            Text(
                                "Saturday             9:00 AM – 5:00 PM"
                            )
                            Text("Sunday               Closed")
                        }
                        .foregroundStyle(.secondary)
                        .padding()
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    colorScheme == .dark
                                    ? Color.white.opacity(0.08)
                                    : lightRed
                                )
                        )
                    }
                    .padding()
                }
                .navigationTitle("Home")
            }
            .tabItem {
                Label(
                    "Home",
                    systemImage: "house.fill"
                )
            }
            .tag(0)
            
            
            // =====================================================
            // BOOKS
            // =====================================================
            
            NavigationStack {
                VStack {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(kjsceRed)
                        
                        TextField(
                            "Search title or author",
                            text: $searchText
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                Color(.secondarySystemBackground)
                            )
                    )
                    .padding(.horizontal)
                    
                    List {
                        Section("Available Books") {
                            
                            ForEach(
                                filteredBooks,
                                id: \.0
                            ) { book in
                                
                                NavigationLink {
                                    BookDetailsView(
                                        title: book.0,
                                        author: book.1,
                                        category: book.2,
                                        icon: book.3,
                                        kjsceRed: kjsceRed
                                    )
                                } label: {
                                    HStack(spacing: 15) {
                                        
                                        Image(
                                            systemName: book.3
                                        )
                                        .font(.title2)
                                        .foregroundStyle(kjsceRed)
                                        .frame(
                                            width: 50,
                                            height: 50
                                        )
                                        .background(
                                            kjsceRed.opacity(0.1)
                                        )
                                        .clipShape(
                                            RoundedRectangle(
                                                cornerRadius: 10
                                            )
                                        )
                                        
                                        VStack(
                                            alignment: .leading
                                        ) {
                                            Text(book.0)
                                                .font(.headline)
                                            
                                            Text(book.1)
                                                .font(.subheadline)
                                                .foregroundStyle(
                                                    .secondary
                                                )
                                            
                                            Text(book.2)
                                                .font(.caption)
                                                .foregroundStyle(
                                                    kjsceRed
                                                )
                                        }
                                        
                                        Spacer()
                                        
                                        Image(
                                            systemName:
                                                "checkmark.circle.fill"
                                        )
                                        .foregroundStyle(.green)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .navigationTitle("Library Books")
            }
            .tabItem {
                Label(
                    "Books",
                    systemImage: "books.vertical.fill"
                )
            }
            .tag(1)
            
            
            // =====================================================
            // BORROWED BOOKS
            // =====================================================
            
            NavigationStack {
                List {
                    
                    Section {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Currently Borrowed")
                                    .font(.headline)
                                
                                Text(
                                    "You have borrowed 2 of 5 books"
                                )
                                .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("2")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(kjsceRed)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Section("My Books") {
                        
                        borrowedBook(
                            title: "Data Structures",
                            author: "Thomas H. Cormen",
                            days: 3,
                            icon: "chart.bar.xaxis"
                        )
                        
                        borrowedBook(
                            title: "Computer Networks",
                            author: "Andrew S. Tanenbaum",
                            days: 8,
                            icon: "network"
                        )
                    }
                    
                    Section("Library Policy") {
                        Text(
                            "Maximum books allowed: 5"
                        )
                        
                        Text(
                            "Standard borrowing period: 14 days"
                        )
                        
                        Text(
                            "Please return books before the due date."
                        )
                    }
                }
                .navigationTitle("My Books")
            }
            .tabItem {
                Label(
                    "Borrowed",
                    systemImage: "book.closed.fill"
                )
            }
            .tag(2)
            
            
            // =====================================================
            // PROFILE
            // =====================================================
            
            NavigationStack {
                List {
                    
                    Section {
                        VStack(spacing: 12) {
                            
                            Image(
                                systemName:
                                    "person.crop.circle.fill"
                            )
                            .font(.system(size: 85))
                            .foregroundStyle(kjsceRed)
                            
                            Text("Student Name")
                                .font(.title2)
                                .bold()
                            
                            Text("KJSCE")
                                .foregroundStyle(.secondary)
                            
                            Text("Computer Engineering")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                    }
                    
                    Section("Student Details") {
                        
                        Label(
                            "Student ID: CE2026001",
                            systemImage:
                                "person.text.rectangle"
                        )
                        
                        Label(
                            "Computer Engineering",
                            systemImage:
                                "graduationcap.fill"
                        )
                        
                        Label(
                            "Library Membership: Active",
                            systemImage:
                                "checkmark.seal.fill"
                        )
                        .foregroundStyle(.green)
                    }
                    
                    Section("Library") {
                        
                        NavigationLink {
                            LibraryRulesView(
                                kjsceRed: kjsceRed
                            )
                        } label: {
                            Label(
                                "Library Rules",
                                systemImage:
                                    "doc.text.fill"
                            )
                        }
                        
                        NavigationLink {
                            SettingsView(
                                kjsceRed: kjsceRed
                            )
                        } label: {
                            Label(
                                "Settings",
                                systemImage:
                                    "gearshape.fill"
                            )
                        }
                    }
                    
                    Section("About") {
                        
                        HStack {
                            Text("College")
                            Spacer()
                            Text("KJSCE")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Application")
                            Spacer()
                            Text("Library Portal")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .navigationTitle("Profile")
            }
            .tabItem {
                Label(
                    "Profile",
                    systemImage:
                        "person.crop.circle.fill"
                )
            }
            .tag(3)
        }
        .tint(kjsceRed)
        .environment(\.locale, locale)
        .environment(
            \.dynamicTypeSize,
            dynamicTypeSize
        )
    }
    
    // MARK: - Statistic Card
    
    func statisticCard(
        number: String,
        title: String,
        icon: String
    ) -> some View {
        
        VStack(spacing: 8) {
            
            Image(systemName: icon)
                .foregroundStyle(kjsceRed)
                .font(.title3)
            
            Text(number)
                .font(.title2)
                .bold()
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    colorScheme == .dark
                    ? Color.white.opacity(0.08)
                    : lightRed
                )
        )
    }
    
    // MARK: - Quick Action
    
    func quickAction(
        title: String,
        icon: String
    ) -> some View {
        
        VStack(spacing: 10) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(kjsceRed)
            
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(kjsceRed.opacity(0.1))
        )
    }
    
    // MARK: - Borrowed Book
    
    func borrowedBook(
        title: String,
        author: String,
        days: Int,
        icon: String
    ) -> some View {
        
        HStack(spacing: 15) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(kjsceRed)
                .frame(
                    width: 50,
                    height: 50
                )
                .background(
                    kjsceRed.opacity(0.1)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 10
                    )
                )
            
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                
                Text(title)
                    .font(.headline)
                
                Text(author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(
                    Date.now.addingTimeInterval(
                        Double(days) * 86400
                    )
                    .formatted(
                        .dateTime
                            .day()
                            .month()
                            .year()
                            .locale(locale)
                    )
                )
                .font(.caption)
                .foregroundStyle(
                    days <= 3 ? .red : .green
                )
            }
            
            Spacer()
            
            VStack {
                
                Image(
                    systemName:
                        days <= 3
                        ? "exclamationmark.triangle.fill"
                        : "checkmark.circle.fill"
                )
                .foregroundStyle(
                    days <= 3
                    ? .orange
                    : .green
                )
                
                Text(
                    days <= 3
                    ? "Due Soon"
                    : "On Time"
                )
                .font(.caption2)
            }
        }
        .padding(.vertical, 5)
    }
}


// =============================================================
// BOOK DETAILS
// =============================================================

struct BookDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    let title: String
    let author: String
    let category: String
    let icon: String
    let kjsceRed: Color
    
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: 22) {
                
                Image(systemName: icon)
                    .font(.system(size: 75))
                    .foregroundStyle(kjsceRed)
                    .frame(
                        width: 160,
                        height: 190
                    )
                    .background(
                        kjsceRed.opacity(0.1)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                    )
                
                Text(title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(author)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {
                    
                    infoRow(
                        icon: "books.vertical.fill",
                        title: "Category",
                        value: category
                    )
                    
                    infoRow(
                        icon: "barcode",
                        title: "ISBN",
                        value: "978-1-23456-789-0"
                    )
                    
                    infoRow(
                        icon: "building.columns.fill",
                        title: "Location",
                        value: "KJSCE Central Library"
                    )
                    
                    infoRow(
                        icon: "checkmark.circle.fill",
                        title: "Availability",
                        value: "Available"
                    )
                }
                
                Button {
                    showAlert = true
                } label: {
                    Text("Borrow Book")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(kjsceRed)
                        .foregroundStyle(.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12
                            )
                        )
                }
                
                Button("Close") {
                    dismiss()
                }
                .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Book Borrowed",
            isPresented: $showAlert
        ) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(
                "\(title) has been added to your borrowed books."
            )
        }
    }
    
    func infoRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {
        
        HStack {
            
            Image(systemName: icon)
                .foregroundStyle(kjsceRed)
                .frame(width: 30)
            
            VStack(
                alignment: .leading
            ) {
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
    }
}


// =============================================================
// LIBRARY RULES
// =============================================================

struct LibraryRulesView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let kjsceRed: Color
    
    var body: some View {
        
        List {
            
            Section("Borrowing Rules") {
                
                Label(
                    "Maximum 5 books can be borrowed.",
                    systemImage: "books.vertical"
                )
                
                Label(
                    "Borrowing period is 14 days.",
                    systemImage: "calendar"
                )
                
                Label(
                    "Return books before the due date.",
                    systemImage: "clock"
                )
            }
            
            Section("Library Etiquette") {
                
                Label(
                    "Maintain silence.",
                    systemImage:
                        "speaker.slash.fill"
                )
                
                Label(
                    "Keep mobile phones silent.",
                    systemImage: "iphone"
                )
                
                Label(
                    "Do not damage library books.",
                    systemImage: "book.fill"
                )
                
                Label(
                    "Food and drinks are not allowed.",
                    systemImage: "fork.knife"
                )
            }
            
            Section("Fine Policy") {
                
                Text(
                    "Late returns may attract fines according to KJSCE library policy."
                )
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Library Rules")
        .toolbar {
            
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                
                Button("Done") {
                    dismiss()
                }
                .foregroundStyle(kjsceRed)
            }
        }
    }
}


// =============================================================
// SETTINGS
// =============================================================

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.locale) private var locale
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    @AppStorage("notifications")
    private var notifications = true
    
    let kjsceRed: Color
    
    // MARK: Dynamic Type Label
    
    private var dynamicTypeSizeLabel: String {
        
        switch dynamicTypeSize {
            
        case .xSmall:
            return "Extra Small"
            
        case .small:
            return "Small"
            
        case .medium:
            return "Medium"
            
        case .large:
            return "Large"
            
        case .xLarge:
            return "Extra Large"
            
        case .xxLarge:
            return "XX Large"
            
        case .xxxLarge:
            return "XXX Large"
            
        case .accessibility1:
            return "Accessibility 1"
            
        case .accessibility2:
            return "Accessibility 2"
            
        case .accessibility3:
            return "Accessibility 3"
            
        case .accessibility4:
            return "Accessibility 4"
            
        case .accessibility5:
            return "Accessibility 5"
            
        @unknown default:
            return "System Default"
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
                // Appearance
                Section("Appearance") {
                    
                    HStack {
                        
                        Label(
                            "Color Scheme",
                            systemImage:
                                "circle.lefthalf.filled"
                        )
                        
                        Spacer()
                        
                        Text(
                            colorScheme == .dark
                            ? "Dark"
                            : "Light"
                        )
                        .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        
                        Label(
                            "Dynamic Type",
                            systemImage:
                                "textformat.size"
                        )
                        
                        Spacer()
                        
                        Text(dynamicTypeSizeLabel)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Notifications
                Section("Notifications") {
                    
                    Toggle(
                        "Due Date Reminders",
                        isOn: $notifications
                    )
                    .tint(kjsceRed)
                }
                
                // Locale
                Section("Language & Region") {
                    
                    HStack {
                        
                        Label(
                            "Locale",
                            systemImage: "globe"
                        )
                        
                        Spacer()
                        
                        Text(locale.identifier)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Accessibility
                Section("Accessibility") {
                    
                    Text(
                        "The KJSCE Library app supports Dynamic Type. Text automatically adapts to the user's preferred accessibility size."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(kjsceRed)
                }
            }
        }
    }
}


// =============================================================
// PREVIEW
// =============================================================

#Preview {
    ContentView()
}
