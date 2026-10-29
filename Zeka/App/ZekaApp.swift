import SwiftUI
import SwiftData

@main
struct ZekaApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .tint(AppTheme.accent)
        }
        .modelContainer(for: GameResult.self)
    }
}
