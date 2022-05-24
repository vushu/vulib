module vulib.graphics2d.opengl.openglrenderer;
import vulib.graphics2d.opengl.renderdata;
import vulib.graphics2d.opengl.shader;
import vulib.graphics2d.vertex;
import vulib.graphics2d.renderer;
import vulib.window.window;
import bindbc.sdl;
import bindbc.opengl;
import dplug.math;
import std.conv : to;
import std.stdio;

class OpenGLRenderer : Renderer
{
    private : enum MaxQuadCount = 1000;
    enum MaxVertexCount = MaxQuadCount * 4;
    enum MaxIndexCount = MaxQuadCount * 6;
    enum MaxNumberOfTextures = 8;
    vec2f[4] defaultTextureCoords =
        [vec2f(1, 1),
            vec2f(1, 0),
            vec2f(0, 0),
            vec2f(0, 1)];

    int[8] textureSlots = [0, 1, 2, 3, 4, 5, 6, 7];
    Window _window;
    RenderData _renderData;
    Shader _shader;
    int[5] _attributeIds = [0, 1, 2, 3, 4];

    bool prepareBuffers()
    {
        _renderData.vertexBuffer = cast(Vertex*) new Vertex[](MaxNumberOfTextures);

        glGenVertexArrays(1, &_renderData.quadVertexArrayPtr);
        glBindVertexArray(_renderData.quadVertexArrayPtr);

        glGenBuffers(1, &_renderData.quadVertexBufferPtr);
        glBindBuffer(GL_ARRAY_BUFFER, _renderData.quadVertexBufferPtr);

        GLenum err = glGetError();
        if (err != GL_NO_ERROR)
        {
            glDeleteBuffers(1, &_renderData.quadVertexBufferPtr);
            return false;
        }
        return true;

    }

    bool foundGLError()
    {
        bool any_error = false;
        GLenum err;
        while ((err = glGetError()) != GL_NO_ERROR)
        {
            debug writeln("GL CHECK ERROR: ", to!string(err));
            any_error = true;
        }
        return any_error;
    }

    void enableVertexAttribArray(bool enable)
    {
        if (enable)
        {
            foreach (id; _attributeIds)
            {
                glEnableVertexAttribArray(id);
            }
        }
        else
        {
            foreach (id; _attributeIds)
            {
                glDisableVertexAttribArray(id);
            }
        }
    }

    void setupGPUData()
    {
        enableVertexAttribArray(true);
        definingAttributeData();
        enableVertexAttribArray(false);
    }

    void definingAttributeData()
    {
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)(0 * float.sizeof));
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)(3 * float.sizeof));
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)(7 * float.sizeof));
        glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)(9 * float.sizeof));
        glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)(10 * float
                .sizeof));
        // math for next stride
        // last_size + last stride 
        // 3 + 0 
        // 4 + 3
        // 2 + 7 
        // 1 + 9
    }

public:
    this(Window window)
    {
        this._window = window;
    }

    bool initialize()
    {
        _shader.compile();
        prepareBuffers();

        return true;
    }

}

unittest
{
    import vulib.window.opengl;
    import vulib.graphics2d;
    import bindbc.opengl;
    import std.stdio;

    OpenGLWindow window = new OpenGLWindow();
    assert(window.initialize());
    OpenGLRenderer openglRenderer = new OpenGLRenderer(window);
    assert(openglRenderer.prepareBuffers());

    openglRenderer.enableVertexAttribArray(true);
    assert(!openglRenderer.foundGLError());
    openglRenderer.definingAttributeData();
    assert(!openglRenderer.foundGLError());
    openglRenderer.enableVertexAttribArray(false);
    assert(!openglRenderer.foundGLError());

}
