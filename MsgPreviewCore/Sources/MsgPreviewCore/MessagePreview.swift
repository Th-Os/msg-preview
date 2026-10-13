import Foundation
import MsgReader
import UniformTypeIdentifiers

/// Everything Quick Look needs from an Outlook .msg file.
public struct MessagePreview {
    public struct Attachment {
        public let data: Data
        public let type: UTType
    }

    /// Subject, or nil when the message has none so the caller can fall back to the filename.
    public let title: String?
    public let text: String
    /// Keyed by attachment filename including extension.
    public let attachments: [String: Attachment]

    public init(data: Data) throws {
        let file = try MsgFile(data: data)
        let subject = file.subject ?? ""
        title = subject.isEmpty ? nil : subject
        text = file.body ?? ""

        var attachments: [String: Attachment] = [:]
        for attachment in file.attachments {
            guard let name = attachment.name, let data = attachment.attachDataBinary else { continue }
            let type = UTType(filenameExtension: (name as NSString).pathExtension) ?? .data
            attachments[name] = Attachment(data: data, type: type)
        }
        self.attachments = attachments
    }
}
