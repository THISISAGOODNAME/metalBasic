//: Playground - noun: a place where people can play

import MetalKit
import PlaygroundSupport

let frame = NSRect(x: 0, y: 0, width: 300, height: 300)
let device = MTLCreateSystemDefaultDevice()!
let view = MetalView(frame: frame, device: device)
PlaygroundPage.current.liveView = view
