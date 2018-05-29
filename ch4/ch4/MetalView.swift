//
//  MetalView.swift
//  ch4
//
//  Created by AICDG on 2018/5/29.
//  Copyright © 2018年 Ya. All rights reserved.
//

import MetalKit

class MetalView: MTKView {
    
    var commandQueue: MTLCommandQueue?
    var rps: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    
    struct Vertex {
        var position: vector_float4
        var color: vector_float4
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        createBuffer()
        registerShaders()
    }
    
    func createBuffer() {
        device = MTLCreateSystemDefaultDevice()!
        commandQueue = device!.makeCommandQueue()
        let vertexData = [Vertex(position: [-0.5, -0.5, 0.0, 1.0], color: [1, 0, 0, 1]),
                          Vertex(position: [ 0.5, -0.5, 0.0, 1.0], color: [0, 1, 0, 1]),
                          Vertex(position: [ 0.0,  0.5, 0.0, 1.0], color: [0, 0, 1, 1])]
        vertexBuffer = device!.makeBuffer(bytes: vertexData, length: MemoryLayout<Vertex>.size * 3, options: [])
    }
    
    func registerShaders() {
        let library = device!.makeDefaultLibrary()!
        let vert_func = library.makeFunction(name: "vert_func")
        let frag_func = library.makeFunction(name: "frag_func")
        let rpld = MTLRenderPipelineDescriptor()
        rpld.vertexFunction = vert_func
        rpld.fragmentFunction = frag_func
        rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
        rps = try! device!.makeRenderPipelineState(descriptor: rpld)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
            rpd.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1.0)
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
