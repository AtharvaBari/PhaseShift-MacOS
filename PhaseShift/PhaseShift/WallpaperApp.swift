import SwiftUI
import AppKit
import Sparkle

@main
struct WallpaperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // We use AppDelegate to manage windows and the menu bar 
        // to maintain compatibility with older macOS versions.
        Settings {
            EmptyView()
        }
    }
}

// A helper for versions that don't support certain SwiftUI scenes
struct EmptyScene: Scene {
    var body: some Scene {
        Settings { EmptyView() }
    }
}

extension NSApplication {
    func customActivate() {
        // Activate app (so menu bar and windows are interactable)
        // ignoringOtherApps: true brings it to front
        activate(ignoringOtherApps: true)
    }
}
