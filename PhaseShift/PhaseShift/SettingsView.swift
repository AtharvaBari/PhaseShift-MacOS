import SwiftUI
import ServiceManagement
import Sparkle

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showUpdatePopover: Bool = false
    @State private var showRestartAlert: Bool = false
    @State private var showResetConfirm: Bool = false
    @State private var selectedTab: SettingsTab? = .general
    @State private var launchAtLogin: Bool = false
    @State private var selectedThemeId: String = "default"

    enum SettingsTab: String, CaseIterable, Identifiable {
        case general = "General"
        case age = "Age Timer"
        case year = "Year Grid"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header / Preview Area
            // Pass the LIVE viewModel to preview so we see changes instantly
            PreviewView(viewModel: viewModel)
                .padding()
                .background(Color(nsColor: .windowBackgroundColor))
            
            Divider()
            
            // TABS / FORM
           TabView(selection: $selectedTab) {
                GeneralSettingsView
                    .tabItem { Label("General", systemImage: "gearshape.fill") }
                    .tag(SettingsTab.general)
                
                AgeSettingsView
                    .tabItem { Label("Age Timer", systemImage: "clock.fill") }
                    .tag(SettingsTab.age)
                
                YearSettingsView
                    .tabItem { Label("Year Grid", systemImage: "calendar.circle.fill") }
                    .tag(SettingsTab.year)
            }
           
           Divider()
           
           // FOOTER ACTIONS
            HStack {
                Button("Check for Updates") {
                    AppDelegate.shared.updaterController?.checkForUpdates(nil)
                }
                
                Spacer()
                
                Button(role: .destructive) {
                    showResetConfirm = true
                } label: {
                    Text("Reset")
                }
                .alert("Reset to Defaults?", isPresented: $showResetConfirm) {
                    Button("Cancel", role: .cancel) { }
                    Button("Reset", role: .destructive) {
                        viewModel.resetToDefaults()
                        _ = viewModel.save()
                    }
                } message: {
                    Text("This will restore all settings to their original values.")
                }
                
                Button("Apply Changes") {
                    _ = viewModel.save()
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            Text("PhaseShift v2.0.8")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
        }
        .frame(width: 500, height: 720) 
        .onAppear {
            if #available(macOS 13.0, *) {
                launchAtLogin = SMAppService.mainApp.status == .enabled
            } else {
                launchAtLogin = false
            }
        }
    }
    
    var GeneralSettingsView: some View {
        Form {
            Section("Widget Mode") {
                Picker(selection: $viewModel.viewMode) {
                    Label("Age Timer", systemImage: "clock").tag("age")
                    Label("Year Progress", systemImage: "calendar").tag("year")
                } label: {
                    Text("Active Mode")
                }
                .pickerStyle(.segmented)
            }
            
            Section("Monitors") {
                Picker("Show On", selection: $viewModel.displayMode) {
                    Text("All Displays").tag(-1)
                    Divider()
                    ForEach(Array(NSScreen.screens.enumerated()), id: \.offset) { index, screen in
                        Text("Display \(index + 1) \(index == 0 ? "(Main)" : "")").tag(index)
                    }
                }
            }
            
            Section("Position (Global)") {
                VStack(alignment: .leading) {
                    HStack { Text("X Offset"); Spacer(); Text("\(Int(viewModel.offsetX))").foregroundColor(.secondary) }
                    Slider(value: $viewModel.offsetX, in: -800...800, step: 10)
                }
                VStack(alignment: .leading) {
                    HStack { Text("Y Offset"); Spacer(); Text("\(Int(viewModel.offsetY))").foregroundColor(.secondary) }
                    Slider(value: $viewModel.offsetY, in: -600...600, step: 10)
                }
                HStack { Spacer(); Button("Reset Position") { viewModel.offsetX = 0; viewModel.offsetY = 0 } }
            }
            
            Section("Themes") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                    ForEach(ThemePreset.allPresets) { theme in
                        Button {
                            selectedThemeId = theme.id
                            viewModel.applyTheme(theme)
                        } label: {
                            VStack(spacing: 6) {
                                Circle()
                                    .fill(Color(hex: theme.textColorHex))
                                    .frame(width: 24, height: 24)
                                    .shadow(color: Color(hex: theme.shadowColorHex).opacity(0.6), radius: 4)
                                Text(theme.name)
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedThemeId == theme.id ? Color.accentColor.opacity(0.15) : Color.clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedThemeId == theme.id ? Color.accentColor : Color.gray.opacity(0.2), lineWidth: selectedThemeId == theme.id ? 2 : 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
            
            Section("System") {
                Toggle("Launch at Login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { newValue in
                        toggleLaunchAtLogin(enabled: newValue)
                    }
                
                Button(role: .destructive) {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Text("Quit Phase Shift")
                }
            }
        }
        .conditionalFormStyleGrouped()
    }
    
    var AgeSettingsView: some View {
        Group {
            if viewModel.viewMode == "age" {
                Form {
                    Section("Data") {
                        DatePicker("Date of Birth", selection: $viewModel.birthDate, displayedComponents: [.date, .hourAndMinute])
                    }
                    
                    Section("Typography") {
                        Picker("Font Design", selection: $viewModel.fontDesign) {
                            Text("Default").tag("default")
                            Text("Rounded").tag("rounded")
                            Text("Serif").tag("serif")
                            Text("Monospaced").tag("monospaced")
                        }
                        
                        VStack(alignment: .leading) {
                            HStack { Text("Size"); Spacer(); Text("\(Int(viewModel.yearSize)) pts").foregroundColor(.secondary) }
                            Slider(value: $viewModel.yearSize, in: 20...500, step: 5)
                        }
                        VStack(alignment: .leading) {
                            HStack { Text("Detail Scale"); Spacer(); Text("\(Int(viewModel.componentScale * 100))%").foregroundColor(.secondary) }
                            Slider(value: $viewModel.componentScale, in: 0.1...1.0, step: 0.05)
                        }
                        VStack(alignment: .leading) {
                            HStack { Text("Label Spacing"); Spacer(); Text("\(Int(viewModel.labelSpacing))").foregroundColor(.secondary) }
                            Slider(value: $viewModel.labelSpacing, in: -50...50, step: 1)
                        }
                    }
                    
                    appearanceSection
                }
                .conditionalFormStyleGrouped()
            } else {
                DisabledStateView(message: "Switch to Age Mode to edit these settings.")
            }
        }
    }
    
    var YearSettingsView: some View {
        Group {
            if viewModel.viewMode == "year" {
                Form {
                    Section("Layout") {
                        Picker("Percentage Position", selection: $viewModel.yearPctPosition) {
                            Text("Top Leading").tag("topLeading")
                            Text("Top").tag("top")
                            Text("Top Trailing").tag("topTrailing")
                            Text("Right").tag("right")
                            Text("Bottom Trailing").tag("bottomTrailing")
                            Text("Bottom").tag("bottom")
                            Text("Bottom Leading").tag("bottomLeading")
                            Text("Left").tag("left")
                        }
                    }
                    
                    Section("Grid Dimensions") {
                        VStack(alignment: .leading) {
                            HStack { Text("Grid Width"); Spacer(); Text("\(Int(viewModel.yearGridWidth))").foregroundColor(.secondary) }
                            Slider(value: $viewModel.yearGridWidth, in: 100...1000, step: 10)
                        }
                        VStack(alignment: .leading) {
                            HStack { Text("Dot Size"); Spacer(); Text("\(Int(viewModel.yearDotSize))").foregroundColor(.secondary) }
                            Slider(value: $viewModel.yearDotSize, in: 2...50, step: 1)
                        }
                        VStack(alignment: .leading) {
                            HStack { Text("Spacing"); Spacer(); Text("\(Int(viewModel.yearDotSpacingLocal))").foregroundColor(.secondary) }
                            Slider(value: $viewModel.yearDotSpacingLocal, in: 0...50, step: 1)
                        }
                    }
                    
                    Section("Typography") {
                        VStack(alignment: .leading) {
                            HStack { Text("Text Size"); Spacer(); Text("\(Int(viewModel.yearPtcSize)) pts").foregroundColor(.secondary) }
                            Slider(value: $viewModel.yearPtcSize, in: 20...500, step: 5)
                        }
                    }
                    
                    appearanceSection
                }
                .conditionalFormStyleGrouped()
            } else {
                DisabledStateView(message: "Switch to Year Mode to edit these settings.")
            }
        }
    }
    
    var appearanceSection: some View {
        Section("Appearance") {
            ColorPicker("Text Color", selection: Binding(get: { Color(hex: viewModel.textColorHex) }, set: { viewModel.textColorHex = $0.toHex() ?? "FFFFFF" }))
            ColorPicker("Shadow Color", selection: Binding(get: { Color(hex: viewModel.shadowColorHex) }, set: { viewModel.shadowColorHex = $0.toHex() ?? "000000" }))
            
            VStack(alignment: .leading) {
                HStack { Text("Blur"); Spacer(); Text("\(Int(viewModel.shadowRadius))").foregroundColor(.secondary) }
                Slider(value: $viewModel.shadowRadius, in: 0...20, step: 0.5)
            }
            VStack(alignment: .leading) {
                HStack { Text("Opacity"); Spacer(); Text("\(Int(viewModel.shadowOpacity * 100))%").foregroundColor(.secondary) }
                Slider(value: $viewModel.shadowOpacity, in: 0...1, step: 0.05)
            }
            VStack(alignment: .leading) {
                HStack { Text("Y Offset"); Spacer(); Text("\(Int(viewModel.shadowOffsetY))").foregroundColor(.secondary) }
                Slider(value: $viewModel.shadowOffsetY, in: 0...20, step: 0.5)
            }
        }
    }

    private func toggleLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to toggle launch at login: \(error)")
            }
        } else {
            // Fallback for macOS < 13 could go here (e.g. SMLoginItemSetEnabled)
            print("Automatic launch at login toggle is not supported on this version of macOS.")
        }
    }
}

struct DisabledStateView: View {
    let message: String
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "lock.fill")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

extension View {
    @ViewBuilder
    func conditionalFormStyleGrouped() -> some View {
        if #available(macOS 13.0, *) {
            self.formStyle(.grouped)
        } else {
            self
        }
    }
}
