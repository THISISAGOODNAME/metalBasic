//
//  MetalView.swift
//  ch3
//
//  Created by AICDG on 2018/5/28.
//  Copyright © 2018年 Ya. All rights reserved.
//

import MetalKit

class MetalView: MTKView {
    
    var commandQueue: MTLCommandQueue?
    var rps: MTLRenderPipelineState?
    var vertexData: [Float]?
    var vertexBuffer: MTLBuffer?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        render()
    }
    
    func render() {
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device!.makeCommandQueue()
        vertexData = [-0.5, -0.5, 0.0, 1.0,
                       0.5, -0.5, 0.0, 1.0,
                       0.0,  0.5, 0.0, 1.0]
        let dataSize = vertexData!.count * MemoryLayout<Float>.size
        vertexBuffer = device!.makeBuffer(bytes: vertexData!, length: dataSize, options: [])
        let libaray = device!.makeDefaultLibrary()!
        let vert_func = libaray.makeFunction(name: "vert_func")
        let frag_func = libaray.makeFunction(name: "frag_func")
        let rpld = MTLRenderPipelineDescriptor()
        rpld.vertexFunction = vert_func
        rpld.fragmentFunction = frag_func
        rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            try rps = device!.makeRenderPipelineState(descriptor: rpld)
        } catch let error {
            self.printView("\(error)")
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
            rpd.colorAttachments[0].clearColor = MTLClearColorMake(0, 0.5, 0.5, 1.0)
            let commandBuffer = commandQueue!.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            commandEncoder?.setRenderPipelineState(rps!)
            commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            commandEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
    
}
