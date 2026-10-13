//
//  Item.swift
//  msg-preview
//
//  Created by Thomas Oswald on 10.07.24.
//

#if DEBUG
import Foundation
import SwiftData
import MsgPreviewCore

@Model
final class Item {
    var title: String
    var path: String

    init(title: String, path: String) {
        self.title = title
        self.path = path
    }

    func preview() throws -> MessagePreview {
        try MessagePreview(data: Data(contentsOf: URL(fileURLWithPath: path)))
    }
}
#endif
