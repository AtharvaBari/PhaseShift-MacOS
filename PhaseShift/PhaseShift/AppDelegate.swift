import Cocoa
import SwiftUI
import Sparkle

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var shared: AppDelegate!
    
    override init() {
        super.init()
        AppDelegate.shared = self
    }
    
    var wallpaperWindows: [NSWindow] = []
    var settingsWindow: NSWindow? // The indestructible settings window
    
    // Sparkle Updater Controller
    var updaterController: SPUStandardUpdaterController?
    
    // Status Bar Item (for compatibility with older macOS)
    var statusItem: NSStatusItem?
    
    // Simple debounce tracking
    private var setupWorkItem: DispatchWorkItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize Sparkle
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        
        // Setup Menu Bar for older macOS compatibility
        setupStatusItem()
        
        // Initial setup on main thread
        DispatchQueue.main.async { [weak self] in
            self?.scheduleSetupWindows()
        }
        
        // Listen for screen changes
        NotificationCenter.default.addObserver(self, selector: #selector(screenConfigChanged), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        
        // Listen for settings changes
        NotificationCenter.default.addObserver(self, selector: #selector(settingsApplied), name: NSNotification.Name("SettingsApplied"), object: nil)
        
        // Listen for sleep/wake
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onSleep), name: NSWorkspace.willSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onWake), name: NSWorkspace.didWakeNotification, object: nil)
    }

    @objc func onSleep() {
        // Cancel pending setup
        setupWorkItem?.cancel()

        // Hide and close windows
        for window in wallpaperWindows {
            window.orderOut(nil)
            window.close()
        }
        wallpaperWindows.removeAll()
    }

    @objc func onWake() {
        // Schedule setup with a delay to allow screens to wake up
        scheduleSetupWindows(delay: 2.0)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func openSettingsWindow() {
        // If it exists, just bring it to front
        if let window = settingsWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // Create it
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 700),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window.center()
        window.title = "Phase Shift Settings"
        window.contentView = NSHostingView(rootView: SettingsView())
        window.isReleasedWhenClosed = false // Critical: Don't destroy on close
        
        // Ensure fixed size
        window.setContentSize(NSSize(width: 500, height: 700))
        window.minSize = NSSize(width: 500, height: 700)
        window.maxSize = NSSize(width: 500, height: 700)
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        self.settingsWindow = window
    }
    
    @objc func screenConfigChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.scheduleSetupWindows()
        }
    }
    
    @objc func settingsApplied() {
        DispatchQueue.main.async { [weak self] in
            self?.scheduleSetupWindows(delay: 0.2)
        }
    }
    
    func scheduleSetupWindows(delay: TimeInterval = 1.0) {
        setupWorkItem?.cancel()
        
        let item = DispatchWorkItem { [weak self] in
            self?.setupWindows()
        }
        
        setupWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
    }
    
    func setupWindows() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { self.setupWindows() }
            return
        }
        
        // Safely close existing windows to prevent crash
        let oldWindows = wallpaperWindows
        wallpaperWindows.removeAll()
        
        for window in oldWindows {
            window.close()
        }
        
        let defaults = UserDefaults.standard
        let mode = defaults.object(forKey: "displayMode") as? Int ?? -1 // Default to All
        
        let screens = NSScreen.screens
        
        for (index, screen) in screens.enumerated() {
            var shouldShow = false
            
            if mode == -1 { 
                shouldShow = true
            } else if mode == index {
                shouldShow = true
            }
            
            if shouldShow {
                createWindow(for: screen)
            }
        }
    }

    func createWindow(for screen: NSScreen) {
        if screen.frame.width <= 0 || screen.frame.height <= 0 {
            return
        }

        let contentView = ContentView()
        
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        
        window.level = NSWindow.Level(Int(CGWindowLevelForKey(.desktopIconWindow)) - 1)
        
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .ignoresCycle
        ]
        
        // Visuals
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.ignoresMouseEvents = true 
        
        // Set frame explicitly to screen
        window.setFrame(screen.frame, display: true)
        
        window.contentView = NSHostingView(rootView: contentView)
        window.orderFront(nil)
        
        wallpaperWindows.append(window)
    }

    // MARK: - Status Bar / Menu
    
    func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "clock", accessibilityDescription: "Phase Shift")
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettingsMenuAction), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: "Check for Updates...", action: #selector(checkForUpdatesAction), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitAction), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func openSettingsMenuAction() {
        openSettingsWindow()
    }
    
    @objc func checkForUpdatesAction() {
        updaterController?.checkForUpdates(nil)
    }
    
    @objc func quitAction() {
        NSApplication.shared.terminate(nil)
    }
}
