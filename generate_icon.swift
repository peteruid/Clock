#!/usr/bin/env swift

import AppKit
import CoreGraphics
import Foundation

struct IconColors {
    let bgTop: CGColor
    let bgBottom: CGColor
    let faceRadius: CGFloat    // as fraction of icon size
    let faceTop: CGColor
    let faceBottom: CGColor
    let bezel: CGColor
    let tickMajor: CGColor
    let tickMinor: CGColor
    let hand: CGColor
    let handShadow: CGColor
    let centerDot: CGColor
    let centerInner: CGColor
}

let darkScheme = IconColors(
    bgTop:       CGColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1.0),
    bgBottom:    CGColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0),
    faceRadius:  0.44,
    faceTop:     CGColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1.0),
    faceBottom:  CGColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0),
    bezel:       CGColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0),
    tickMajor:   CGColor(red: 0.85, green: 0.85, blue: 0.88, alpha: 1.0),
    tickMinor:   CGColor(red: 0.50, green: 0.50, blue: 0.53, alpha: 0.7),
    hand:        CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
    handShadow:  CGColor(red: 0, green: 0, blue: 0, alpha: 0.4),
    centerDot:   CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
    centerInner: CGColor(red: 0.14, green: 0.14, blue: 0.16, alpha: 1.0)
)

let lightScheme = IconColors(
    bgTop:       CGColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1.0),
    bgBottom:    CGColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0),
    faceRadius:  0.38,
    faceTop:     CGColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0),
    faceBottom:  CGColor(red: 0.88, green: 0.88, blue: 0.90, alpha: 1.0),
    bezel:       CGColor(red: 0.75, green: 0.75, blue: 0.77, alpha: 1.0),
    tickMajor:   CGColor(red: 0.15, green: 0.15, blue: 0.18, alpha: 1.0),
    tickMinor:   CGColor(red: 0.45, green: 0.45, blue: 0.48, alpha: 0.7),
    hand:        CGColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0),
    handShadow:  CGColor(red: 0, green: 0, blue: 0, alpha: 0.15),
    centerDot:   CGColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0),
    centerInner: CGColor(red: 0.92, green: 0.92, blue: 0.93, alpha: 1.0)
)

func drawIcon(size: CGFloat, colors: IconColors) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    guard let ctx = NSGraphicsContext.current?.cgContext else {
        image.unlockFocus()
        return image
    }

    let s = size
    let cx = s / 2
    let cy = s / 2
    let radius = s * colors.faceRadius

    // --- Background rounded rect ---
    ctx.saveGState()
    let bgRect = CGRect(x: 0, y: 0, width: s, height: s)
    let bgRadius = s * 0.22
    let bgPath = CGPath(roundedRect: bgRect, cornerWidth: bgRadius, cornerHeight: bgRadius, transform: nil)
    ctx.addPath(bgPath)
    ctx.clip()
    let bgGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                 colors: [colors.bgTop, colors.bgBottom] as CFArray,
                                 locations: [0.0, 1.0])!
    ctx.drawLinearGradient(bgGradient,
                           start: CGPoint(x: s/2, y: s),
                           end: CGPoint(x: s/2, y: 0),
                           options: [])
    ctx.restoreGState()

    // --- Circle face with gradient ---
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -s * 0.015), blur: s * 0.04,
                   color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.4))
    let circlePath = CGPath(ellipseIn: CGRect(x: cx - radius, y: cy - radius,
                                               width: radius * 2, height: radius * 2), transform: nil)
    ctx.addPath(circlePath)
    ctx.clip()

    let faceGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                   colors: [colors.faceTop, colors.faceBottom] as CFArray,
                                   locations: [0.0, 1.0])!
    ctx.drawLinearGradient(faceGradient,
                           start: CGPoint(x: cx, y: cy + radius),
                           end: CGPoint(x: cx, y: cy - radius),
                           options: [])
    ctx.restoreGState()

    // --- Subtle ring/bezel ---
    ctx.saveGState()
    ctx.setStrokeColor(colors.bezel)
    ctx.setLineWidth(s * 0.02)
    ctx.addPath(circlePath)
    ctx.strokePath()
    ctx.restoreGState()

    // --- Hour tick marks ---
    for i in 0..<12 {
        let angle = CGFloat(i) * (.pi / 6) - .pi / 2
        let isQuarter = (i % 3 == 0)

        let outerR = radius * 0.88
        let innerR = isQuarter ? radius * 0.72 : radius * 0.80
        let tickWidth = isQuarter ? s * 0.028 : s * 0.014

        let outerX = cx + outerR * cos(angle)
        let outerY = cy + outerR * sin(angle)
        let innerX = cx + innerR * cos(angle)
        let innerY = cy + innerR * sin(angle)

        ctx.saveGState()
        ctx.setStrokeColor(isQuarter ? colors.tickMajor : colors.tickMinor)
        ctx.setLineWidth(tickWidth)
        ctx.setLineCap(.round)
        ctx.move(to: CGPoint(x: innerX, y: innerY))
        ctx.addLine(to: CGPoint(x: outerX, y: outerY))
        ctx.strokePath()
        ctx.restoreGState()
    }

    // --- Clock hands (10:10 position) ---
    let hourAngle: CGFloat = -(.pi / 6) * 2 - .pi / 2
    let hourLength = radius * 0.48
    let hourWidth = s * 0.045

    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: s * 0.003, height: -s * 0.003), blur: s * 0.008,
                   color: colors.handShadow)
    ctx.setStrokeColor(colors.hand)
    ctx.setLineWidth(hourWidth)
    ctx.setLineCap(.round)
    ctx.move(to: CGPoint(x: cx, y: cy))
    ctx.addLine(to: CGPoint(x: cx + hourLength * cos(hourAngle),
                             y: cy + hourLength * sin(hourAngle)))
    ctx.strokePath()
    ctx.restoreGState()

    let minuteAngle: CGFloat = (.pi / 6) * 2 - .pi / 2
    let minuteLength = radius * 0.68
    let minuteWidth = s * 0.03

    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: s * 0.003, height: -s * 0.003), blur: s * 0.008,
                   color: colors.handShadow)
    ctx.setStrokeColor(colors.hand)
    ctx.setLineWidth(minuteWidth)
    ctx.setLineCap(.round)
    ctx.move(to: CGPoint(x: cx, y: cy))
    ctx.addLine(to: CGPoint(x: cx + minuteLength * cos(minuteAngle),
                             y: cy + minuteLength * sin(minuteAngle)))
    ctx.strokePath()
    ctx.restoreGState()

    // --- Center dot ---
    let dotRadius = s * 0.032
    ctx.saveGState()
    ctx.setFillColor(colors.centerDot)
    ctx.fillEllipse(in: CGRect(x: cx - dotRadius, y: cy - dotRadius,
                                width: dotRadius * 2, height: dotRadius * 2))
    ctx.restoreGState()

    let innerDotR = s * 0.012
    ctx.saveGState()
    ctx.setFillColor(colors.centerInner)
    ctx.fillEllipse(in: CGRect(x: cx - innerDotR, y: cy - innerDotR,
                                width: innerDotR * 2, height: innerDotR * 2))
    ctx.restoreGState()

    image.unlockFocus()
    return image
}

// --- Generate both icon sets ---

let allSizes: [(Int, String)] = [
    (16,   "icon_16x16.png"),
    (32,   "icon_16x16@2x.png"),
    (32,   "icon_32x32.png"),
    (64,   "icon_32x32@2x.png"),
    (128,  "icon_128x128.png"),
    (256,  "icon_128x128@2x.png"),
    (256,  "icon_256x256.png"),
    (512,  "icon_256x256@2x.png"),
    (512,  "icon_512x512.png"),
    (1024, "icon_512x512@2x.png"),
]

let fm = FileManager.default

let variants: [(String, IconColors)] = [
    ("AppIcon.iconset", lightScheme),
    ("AppIconLight.iconset", darkScheme),
]

for (iconsetDir, scheme) in variants {
    try? fm.removeItem(atPath: iconsetDir)
    try fm.createDirectory(atPath: iconsetDir, withIntermediateDirectories: true)

    for (size, filename) in allSizes {
        let image = drawIcon(size: CGFloat(size), colors: scheme)
        guard let tiff = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let png = bitmap.representation(using: .png, properties: [:]) else {
            print("Failed to generate \(filename)")
            continue
        }
        let path = "\(iconsetDir)/\(filename)"
        try png.write(to: URL(fileURLWithPath: path))
    }
    print("Generated \(iconsetDir)")
}

print("Done. Run iconutil to convert.")
