module vulib.graphics2d.opengl.renderdata;
import vulib.graphics2d.vertex;
import bindbc.opengl;

struct RenderData
{
    GLuint quadVertexArrayPtr = 0;
    GLuint quadVertexBufferPtr = 0;
    GLuint quadIndexBufferPtr = 0;
    GLuint whiteTexture = 0;

    int whiteTextureSlot = 0;
    int indexCount = 0;

    int[8] textureIds;
    int[8] textureSlotIndex = 0;

    Vertex* vertexBuffer;
    Vertex* currentVertextBufferPtr;


}
