//
//  PreviewProvider.swift
//  msg-ql-extension
//
//  Created by Thomas Oswald on 10.07.24.
//

import Quartz
import MsgPreviewCore

class PreviewProvider: QLPreviewProvider, QLPreviewingController {

    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        let preview = try MessagePreview(data: Data(contentsOf: request.fileURL))

        let reply = QLPreviewReply(dataOfContentType: .plainText, contentSize: CGSize(width: 800, height: 800)) { reply in
            reply.stringEncoding = .utf8
            reply.title = preview.title ?? request.fileURL.lastPathComponent
            return Data(preview.text.utf8)
        }
        reply.attachments = preview.attachments.mapValues {
            QLPreviewReplyAttachment(data: $0.data, contentType: $0.type)
        }
        return reply
    }
}
