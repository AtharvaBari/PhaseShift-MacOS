import SwiftUI
import AppKit
import Sparkle

@main
struct WallpaperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // NO WindowGroup. The settings window is managed manually in AppDelegate.
        
        // Menu Bar Icon
        MenuBarExtra("Phase Shift", systemImage: "clock") {
            Button("Settings...") {
                appDelegate.openSettingsWindow()
            }
            .keyboardShortcut(",", modifiers: .command)
            
            Button("Check for Updates...") {
                appDelegate.updaterController?.updater.checkForUpdates()
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
    }
}

extension NSApplication {
    func customActivate() {
        // Activate app (so menu bar and windows are interactable)
        // ignoringOtherApps: true brings it to front
        activate(ignoringOtherApps: true)
    }
}
