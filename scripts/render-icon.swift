// Renders AppIcon.svg into every PNG the macOS app icon set needs.
// Usage: swift scripts/render-icon.swift   (run from the repository root)
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let svg = root.appendingPathComponent("AppIcon.svg")
let iconset = root.appendingPathComponent("msg-preview/Assets.xcassets/AppIcon.appiconset")

guard let image = NSImage(contentsOf: svg) else {
    fatalError("Could not load \(svg.path)")
}

// (point size, scale) pairs Xcode expects for idiom "mac".
let variants: [(Int, Int)] = [(16, 1), (16, 2), (32, 1), (32, 2), (128, 1), (128, 2), (256, 1), (256, 2), (512, 1), (512, 2)]
var entries: [[String: String]] = []

for (points, scale) in variants {
    let pixels = points * scale
    let name = "icon_\(points)x\(points)@\(scale)x.png"
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels, bitsPerSample: 8,
                               samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                               colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    NSGraphicsContext.current?.imageInterpolation = .high
    image.draw(in: NSRect(x: 0, y: 0, width: pixels, height: pixels), from: .zero, operation: .copy, fraction: 1)
    NSGraphicsContext.restoreGraphicsState()
    try! rep.representation(using: .png, properties: [:])!.write(to: iconset.appendingPathComponent(name))
    entries.append(["filename": name, "idiom": "mac", "scale": "\(scale)x", "size": "\(points)x\(points)"])
}

let manifest: [String: Any] = ["images": entries, "info": ["author": "xcode", "version": 1]]
let json = try! JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted, .sortedKeys])
try! json.write(to: iconset.appendingPathComponent("Contents.json"))
print("Wrote \(entries.count) icons to \(iconset.path)")
