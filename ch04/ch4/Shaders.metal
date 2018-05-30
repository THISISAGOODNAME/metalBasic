//
//  Shaders.metal
//  ch4
//
//  Created by AICDG on 2018/5/29.
//  Copyright © 2018年 Ya. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float4 color;
};

vertex Vertex vert_func(constant Vertex *vertices [[buffer(0)]],
                        uint vid [[vertex_id]]) {
    return vertices[vid];
}

fragment float4 frag_func(Vertex vert [[stage_in]]) {
    return vert.color;
}
