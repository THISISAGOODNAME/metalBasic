#include <metal_stdlib>
using namespace metal;

float dist(float2 point, float2 center, float radius)
{
    return length(point - center) - radius;
}

kernel void compute(texture2d<float, access::write> output [[texture(0)]],
                    uint2 gid [[thread_position_in_grid]])
{
    // 1. single color
//    output.write(float4(0, 0.5, 0.5, 1), gid);
    
    int width = output.get_width();
    int height = output.get_height();
    float red = float(gid.x) / float(width);
    float green = float(gid.y) / float(height);
    
    // 2. gradient
//    output.write(float4(red, green, 0, 1), gid);
    
    float2 uv = float2(gid) / float2(width, height);
    uv = uv * 2.0 - 1.0;
    
    // 3. circle
    bool inside;
//    inside = length(uv) < 0.5;
//    output.write(inside ? float4(0) : float4(red, green, 0, 1), gid);
    
    float distToCircle = dist(uv, float2(0), 0.5);
    
    // 4. eclipse
//    inside = distToCircle < 0;
//    output.write(inside ? float4(0) : float4(1, 0.7, 0, 1) * (1 - distToCircle), gid);
    
    float distToCircle2 = dist(uv, float2(-0.1, 0.1), 0.5);
    
    // 5. eclipse update
    inside = distToCircle2 < 0;
    output.write(inside ? float4(0) : float4(1, 0.7, 0, 1) * (1 - distToCircle), gid);
}
