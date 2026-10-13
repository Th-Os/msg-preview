import XCTest
import UniformTypeIdentifiers
@testable import MsgPreviewCore

final class MessagePreviewTests: XCTestCase {
    // Fixtures from https://github.com/ctabin/jotlmsg (Apache-2.0)
    private func fixture(_ name: String) throws -> Data {
        let url = Bundle.module.url(forResource: name, withExtension: "msg", subdirectory: "Resources")!
        return try Data(contentsOf: url)
    }

    func testTitleIsSubject() throws {
        let preview = try MessagePreview(data: fixture("without-attachment"))
        XCTAssertEqual(preview.title, "This is a message")
    }

    func testTextIsBody() throws {
        let preview = try MessagePreview(data: fixture("without-attachment"))
        XCTAssertEqual(preview.text, "Hello,\n\nThis is a simple message.\n\n.Bye.")
    }

    func testEmptySubjectGivesNoTitle() throws {
        let preview = try MessagePreview(data: fixture("attachment"))
        XCTAssertNil(preview.title)
    }

    func testMessageWithoutAttachmentsHasNone() throws {
        let preview = try MessagePreview(data: fixture("without-attachment"))
        XCTAssertTrue(preview.attachments.isEmpty)
    }

    func testAttachmentKeyedByFilenameWithDataAndType() throws {
        let preview = try MessagePreview(data: fixture("attachment"))
        let attachment = try XCTUnwrap(preview.attachments["myAttachement.txt"])
        XCTAssertEqual(attachment.data.count, 44)
        XCTAssertEqual(attachment.type, .plainText)
    }

    func testInvalidDataThrows() {
        XCTAssertThrowsError(try MessagePreview(data: Data("not a msg file".utf8)))
    }
}
