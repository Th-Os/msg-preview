//
//  msg_previewApp.swift
//  msg-preview
//
//  Created by Thomas Oswald on 10.07.24.
//

import SwiftUI
#if DEBUG
import SwiftData
#endif

@main
struct msg_previewApp: App {
    #if DEBUG
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    #endif

    var body: some Scene {
        Window("msg-preview", id: "main") {
            StatusView()
        }
        .windowResizability(.contentSize)

        #if DEBUG
        Window("Debug", id: "debug") {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        #endif
    }
}

struct StatusView: View {
    // Opens System Settings on the Quick Look extensions list.
    private let extensionsSettingsURL = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences?extensionPointIdentifier=com.apple.quicklook.preview")!

    #if DEBUG
    @Environment(\.openWindow) private var openWindow
    #endif

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 72, height: 72)
                Text("Quick Look for Outlook .msg files")
                    .font(.title2)
                    .bold()
            }

            Text("This app only needs to be installed. The preview itself is provided by a Quick Look extension that macOS registers the first time the app is launched.")

            VStack(alignment: .leading, spacing: 8) {
                Text("1. Keep this app in your Applications folder.")
                Text("2. Enable **msg-ql-extension** under System Settings › General › Login Items & Extensions › Quick Look.")
                Text("3. Select a .msg file in Finder and press Space.")
            }

            HStack {
                Button("Open Extensions Settings") {
                    NSWorkspace.shared.open(extensionsSettingsURL)
                }
                .keyboardShortcut(.defaultAction)

                #if DEBUG
                Button("Debug") {
                    openWindow(id: "debug")
                }
                #endif
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(24)
        .frame(width: 480)
    }
}

#Preview {
    StatusView()
}
