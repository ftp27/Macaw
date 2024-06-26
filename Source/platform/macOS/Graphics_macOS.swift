//
//  Graphics_macOS.swift
//  Macaw
//
//  Created by Daniil Manin on 8/17/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import Foundation

#if os(OSX)
import AppKit

func MGraphicsGetCurrentContext() -> CGContext? {
    NSGraphicsContext.current?.cgContext
}

func MGraphicsPushContext(_ context: CGContext) {
    let cx = NSGraphicsContext(cgContext: context, flipped: true)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = cx
}

func MGraphicsPopContext() {
    NSGraphicsContext.restoreGraphicsState()
}

func MImagePNGRepresentation(_ image: MImage) -> Data? {
    image.lockFocus()
    let rep = NSBitmapImageRep(focusedViewRect: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    image.unlockFocus()

    return rep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
}

func MImageJPEGRepresentation(_ image: MImage, _ quality: CGFloat = 0.9) -> Data? {
    image.lockFocus()
    let rep = NSBitmapImageRep(focusedViewRect: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    image.unlockFocus()

    return rep?.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: quality])
}

func MGraphicsBeginImageContextWithOptions(_ size: CGSize, _ opaque: Bool, _ scale: CGFloat) {
    var scale = scale

    if scale == 0.0 {
        scale = NSScreen.main?.backingScaleFactor ?? 1.0
    }

    let width = Int(size.width * scale)
    let height = Int(size.height * scale)

    if width > 0 && height > 0 {
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo: (opaque ?  CGImageAlphaInfo.noneSkipFirst.rawValue : CGImageAlphaInfo.premultipliedFirst.rawValue)) else {
            return
        }

        ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: CGFloat(height)))
        ctx.scaleBy(x: scale, y: scale)
        ctx.scale = scale
        MGraphicsPushContext(ctx)
    }
}

func MGraphicsGetImageFromCurrentImageContext() -> MImage? {
    guard let ctx = MGraphicsGetCurrentContext(),
          let theCGImage = ctx.makeImage() else {
        return nil
    }
    let scale = ctx.scale
    let size = CGSize(width: CGFloat(ctx.width) / scale, height: CGFloat(ctx.height) / scale)
    let image = NSImage(cgImage: theCGImage, size: size)
    return image
}

func MGraphicsEndImageContext() {
    MGraphicsPopContext()
}

func MNoIntrinsicMetric() -> CGFloat {
    NSView.noIntrinsicMetric
}

#endif
