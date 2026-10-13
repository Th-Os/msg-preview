//
//  msg_previewApp.swift
//  msg-preview
//
//  Created by Thomas Oswald on 10.07.24.
//

import SwiftUI

@main
struct msg_previewApp: App {
    var body: some Scene {
        Window("msg-preview", id: "main") {
            StatusView()
        }
        .windowResizability(.contentSize)
    }
}

struct StatusView: View {
    // Opens System Settings on the Quick Look extensions list.
    private let extensionsSettingsURL = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences?extensionPointIdentifier=com.apple.quicklook.preview")!

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Look for Outlook .msg files")
                .font(.title2)
                .bold()

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
