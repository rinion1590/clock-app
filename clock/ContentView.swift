import SwiftUI

struct DigitalClockView: View {
    @State private var currentTime = Date()
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var binarySeconds: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: currentTime)
        if let seconds = components.second {
            return String(seconds, radix: 2)
        }
        return ""
    }
    
    var body: some View {
        
        VStack {
            Text("\(dateFormatter.string(from: currentTime))")
                .font(.system(size: 160))
                .padding()
                .foregroundColor(.black)
            
            Text(formatBinarySeconds())
                .font(.system(size: 60))
                .padding(.bottom, 50)
                .foregroundColor(.black)
        }
        .hiddenCursor()
        .onAppear {
            startClockTimer()
        }
    }
    
    func formatBinarySeconds() -> String {
        var formattedSeconds = ""
        let paddedBinarySeconds = String(format: "%06d", Int(binarySeconds) ?? 0)
        for character in paddedBinarySeconds {
            if character == "1" {
                formattedSeconds += "◼︎"
            } else {
                formattedSeconds += "◻︎"
            }
        }
        return formattedSeconds
    }
    
    func startClockTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentTime = Date()
        }
    }
}

struct ContentView: View {
    var body: some View {
        DigitalClockView()
    }
}
struct HiddenCursorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                NSCursor.hide()
            }
            .onDisappear {
                NSCursor.unhide()
            }
    }
}

extension View {
    func hiddenCursor() -> some View {
        modifier(HiddenCursorModifier())
    }
}

@main
struct ClockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
