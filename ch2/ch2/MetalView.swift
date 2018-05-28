//
//  MetalView.swift
//  ch2
//
//  Created by AICDG on 2018/5/28.
//  Copyright © 2018年 Ya. All rights reserved.
//

import MetalKit

class MetalView: MTKView {

    required init(coder: NSCoder) {
        super.init(coder: coder)
        device = MTLCreateSystemDefaultDevice()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
            rpd.colorAttachments[0].texture = currentDrawable!.texture
            rpd.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 0.5, blue: 0.31, alpha: 1.0)
            rpd.colorAttachments[0].loadAction = .clear
            let commandBuffer = device!.makeCommandQueue()?.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            commandEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
    
}
