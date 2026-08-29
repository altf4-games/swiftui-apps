import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            DepartmentsView()
                .tabItem {
                    Label("Departments", systemImage: "building.2.fill")
                }
            
            FacultyView()
                .tabItem {
                    Label("Faculty", systemImage: "person.3.fill")
                }
            
            FacilitiesView()
                .tabItem {
                    Label("Facilities", systemImage: "building.columns.fill")
                }
            
            ContactView()
                .tabItem {
                    Label("Contact", systemImage: "phone.fill")
                }
        }
        .tint(.blue)
    }
}

// =====================================================
// MARK: - HOME
// =====================================================

struct HomeView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text("Campus Connect")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("K. J. Somaiya College of Engineering")
                            .font(.headline)
                            .foregroundStyle(.blue)
                        
                        Text("Vidyanagar, Mumbai")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Welcome Card
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 45))
                            .foregroundStyle(.white)
                        
                        Text("Welcome to KJSCE")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("Explore departments, faculty members, campus facilities and important information about KJSCE.")
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [.blue, .indigo],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    // Quick Links
                    Text("Explore KJSCE")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 15
                    ) {
                        
                        QuickCard(
                            title: "Departments",
                            icon: "building.2.fill",
                            color: .blue
                        )
                        
                        QuickCard(
                            title: "Faculty",
                            icon: "person.3.fill",
                            color: .green
                        )
                        
                        QuickCard(
                            title: "Facilities",
                            icon: "building.columns.fill",
                            color: .orange
                        )
                        
                        QuickCard(
                            title: "Contact Us",
                            icon: "phone.fill",
                            color: .purple
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

// =====================================================
// MARK: - QUICK CARD
// =====================================================

struct QuickCard: View {
    
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        
        VStack(spacing: 12) {
            
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(color)
            
            Text(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// =====================================================
// MARK: - DEPARTMENT MODEL
// =====================================================

struct Department: Identifiable {
    
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let location: String
}

// =====================================================
// MARK: - DEPARTMENTS
// =====================================================

struct DepartmentsView: View {
    
    let departments = [
        
        Department(
            name: "Computer Engineering",
            description: "The Computer Engineering department focuses on software development, computer systems, artificial intelligence, data science and emerging technologies.",
            icon: "desktopcomputer",
            location: "KJSCE Campus"
        ),
        
        Department(
            name: "Electronics & Computer Engineering",
            description: "The department combines electronics, communication systems and computer engineering with a focus on modern technological applications.",
            icon: "cpu.fill",
            location: "KJSCE Campus"
        ),
        
        Department(
            name: "Mechanical Engineering",
            description: "Mechanical Engineering covers design, manufacturing, thermal systems, robotics and mechanical technologies.",
            icon: "gearshape.2.fill",
            location: "KJSCE Campus"
        ),
        
        Department(
            name: "Electronics & Telecommunication",
            description: "The department focuses on electronics, communication, signal processing and telecommunications technologies.",
            icon: "antenna.radiowaves.left.and.right",
            location: "KJSCE Campus"
        ),
        
        Department(
            name: "Artificial Intelligence & Data Science",
            description: "Students explore artificial intelligence, machine learning, data analytics and intelligent computing systems.",
            icon: "brain.head.profile",
            location: "KJSCE Campus"
        )
    ]
    
    var body: some View {
        
        NavigationStack {
            
            List(departments) { department in
                
                NavigationLink {
                    DepartmentDetailView(department: department)
                } label: {
                    
                    HStack(spacing: 15) {
                        
                        Image(systemName: department.icon)
                            .font(.title2)
                            .foregroundStyle(.blue)
                            .frame(width: 45, height: 45)
                            .background(.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text(department.name)
                                .font(.headline)
                            
                            Text(department.location)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Departments")
        }
    }
}

// =====================================================
// MARK: - DEPARTMENT DETAIL
// =====================================================

struct DepartmentDetailView: View {
    
    let department: Department
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 25) {
                
                Image(systemName: department.icon)
                    .font(.system(size: 70))
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                
                Text(department.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(department.description)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                InfoRow(
                    icon: "mappin.and.ellipse",
                    title: "Location",
                    value: department.location
                )
            }
            .padding()
        }
        .navigationTitle("Department")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// =====================================================
// MARK: - FACULTY MODEL
// =====================================================

struct FacultyMember: Identifiable {
    
    let id = UUID()
    let name: String
    let department: String
    let designation: String
    let email: String
}

// =====================================================
// MARK: - FACULTY
// =====================================================

struct FacultyView: View {
    
    let faculty = [
        
        FacultyMember(
            name: "Dr. Swapnil Pawar",
            department: "Computer Engineering",
            designation: "Faculty",
            email: "swapnil.pawar@somaiya.edu"
        ),
        
        FacultyMember(
            name: "Dr. Gopal Sonune",
            department: "Computer Engineering",
            designation: "Faculty",
            email: "gopal.sonune@somaiya.edu"
        )
    ]
    
    var body: some View {
        
        NavigationStack {
            
            List(faculty) { person in
                
                NavigationLink {
                    FacultyDetailView(faculty: person)
                } label: {
                    
                    HStack(spacing: 15) {
                        
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.blue)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text(person.name)
                                .font(.headline)
                            
                            Text(person.designation)
                                .font(.subheadline)
                            
                            Text(person.department)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Faculty")
        }
    }
}

// =====================================================
// MARK: - FACULTY DETAIL
// =====================================================

struct FacultyDetailView: View {
    
    let faculty: FacultyMember
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 110))
                    .foregroundStyle(.blue)
                    .padding(.top, 20)
                
                Text(faculty.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(faculty.designation)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text("K. J. Somaiya College of Engineering")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    InfoRow(
                        icon: "building.2.fill",
                        title: "Department",
                        value: faculty.department
                    )
                    
                    InfoRow(
                        icon: "envelope.fill",
                        title: "Email",
                        value: faculty.email
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Faculty")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// =====================================================
// MARK: - FACILITY MODEL
// =====================================================

struct Facility: Identifiable {
    
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let details: String
}

// =====================================================
// MARK: - FACILITIES
// =====================================================

struct FacilitiesView: View {
    
    let facilities = [
        
        Facility(
            name: "Central Library",
            description: "A resource center for students and faculty.",
            icon: "books.vertical.fill",
            details: "Books, journals, digital resources and study spaces."
        ),
        
        Facility(
            name: "Computer Labs",
            description: "Well-equipped computing laboratories for practical learning.",
            icon: "desktopcomputer",
            details: "Modern computer systems and software for academic projects."
        ),
        
        Facility(
            name: "Sports Facilities",
            description: "Facilities for sports and recreational activities.",
            icon: "figure.run",
            details: "Indoor and outdoor spaces for student sports and activities."
        ),
        
        Facility(
            name: "Cafeteria",
            description: "Campus dining facility for students and staff.",
            icon: "fork.knife",
            details: "Food and refreshments available during campus hours."
        ),
        
        Facility(
            name: "Auditorium",
            description: "Venue for seminars, events and college activities.",
            icon: "rectangle.inset.filled",
            details: "Used for technical events, cultural programs and presentations."
        )
    ]
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                LazyVStack(spacing: 15) {
                    
                    ForEach(facilities) { facility in
                        FacilityCard(facility: facility)
                    }
                }
                .padding()
            }
            .navigationTitle("Facilities")
        }
    }
}

// =====================================================
// MARK: - FACILITY CARD
// =====================================================

struct FacilityCard: View {
    
    let facility: Facility
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Image(systemName: facility.icon)
                .font(.system(size: 30))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(facility.name)
                    .font(.headline)
                
                Text(facility.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(facility.details)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

// =====================================================
// MARK: - CONTACT
// =====================================================

struct ContactView: View {
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.blue)
                        .padding(.top, 20)
                    
                    Text("K. J. Somaiya College of Engineering")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("KJSCE")
                        .font(.headline)
                        .foregroundStyle(.blue)
                    
                    Text("Vidyanagar, Mumbai")
                        .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    ContactCard(
                        icon: "mappin.and.ellipse",
                        title: "Campus",
                        value: "K. J. Somaiya College of Engineering\nVidyanagar, Mumbai"
                    )
                    
                    ContactCard(
                        icon: "phone.fill",
                        title: "Phone",
                        value: "College Contact Number"
                    )
                    
                    ContactCard(
                        icon: "envelope.fill",
                        title: "Email",
                        value: "College Email Address"
                    )
                    
                    ContactCard(
                        icon: "globe",
                        title: "Website",
                        value: "www.somaiya.edu"
                    )
                }
                .padding()
            }
            .navigationTitle("Contact Us")
        }
    }
}

// =====================================================
// MARK: - CONTACT CARD
// =====================================================

struct ContactCard: View {
    
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 45, height: 45)
                .background(.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// =====================================================
// MARK: - INFO ROW
// =====================================================

struct InfoRow: View {
    
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 15) {
            
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 25)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.body)
            }
        }
    }
}

// =====================================================
// MARK: - PREVIEW
// =====================================================

#Preview {
    ContentView()
}
