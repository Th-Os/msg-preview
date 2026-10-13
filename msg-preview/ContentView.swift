//
//  ContentView.swift
//  msg-preview
//
//  Created by Thomas Oswald on 10.07.24.
//

#if DEBUG
import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showFilePickerDialog = false
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink(item.title) {
                        ScrollView {
                            Text(previewText(for: item))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button {
                        openWindow(id: "main")
                    } label: {
                        Label("Show Status", systemImage: "info.circle")
                    }
                }
                ToolbarItem {
                    Button {
                        showFilePickerDialog.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .fileImporter(isPresented: $showFilePickerDialog, allowedContentTypes: [UTType(filenameExtension: "msg") ?? .data]) { result in
            if case .success(let url) = result {
                addItem(sourceFileUrl: url)
            }
        }
    }

    private func previewText(for item: Item) -> String {
        do {
            return try item.preview().text
        } catch {
            return "Could not read message: \(error.localizedDescription)"
        }
    }

    private func addItem(sourceFileUrl: URL) {
        // The sandbox only grants temporary access to the picked file, so keep a copy.
        let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(".msg-preview")
        let fileUrl = directoryUrl.appendingPathComponent(sourceFileUrl.lastPathComponent)

        guard sourceFileUrl.startAccessingSecurityScopedResource() else { return }
        defer { sourceFileUrl.stopAccessingSecurityScopedResource() }

        do {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
            try? FileManager.default.removeItem(at: fileUrl)
            try FileManager.default.copyItem(at: sourceFileUrl, to: fileUrl)
        } catch {
            return
        }

        withAnimation {
            modelContext.insert(Item(title: fileUrl.deletingPathExtension().lastPathComponent, path: fileUrl.path))
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
#endif
