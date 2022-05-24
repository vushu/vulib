module vulib.graphics2d.vertex;
import dplug.math;
struct Vertex
{
    vec3f position;
    vec4f color;
    vec2f texcoords;
    float textureId;
    float type;
}