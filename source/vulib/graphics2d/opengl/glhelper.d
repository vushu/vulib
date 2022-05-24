module vulib.graphics2d.opengl.glhelper;
import bindbc.opengl;
import bindbc.sdl;
import std.stdio;
import std.conv : to;
import std.string : toStringz;

void setupOpengl()
{
    version (OSX)
    {
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG); // Always required on Mac
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
    }
    else
    {
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_FLAGS, 0);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);

    }
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
    SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 8);
}

bool makeOpenGLContext(SDL_Window* sdlWindow, ref SDL_GLContext gContext)
{
    gContext = SDL_GL_CreateContext(sdlWindow);
    if (gContext == null)
    {
        debug writeln("OpenGL context couldn't be created! SDL Error: ", to!string(SDL_GetError()));
        return false;
    }
    const GLSupport openglLoaded = loadOpenGL();
    if (openglLoaded != glSupport)
    {
        debug writeln("Error loading OpenGL shared library", to!string(openglLoaded));
        return false;
    }

    SDL_GL_MakeCurrent(sdlWindow, gContext);

    SDL_GL_SetSwapInterval(1); // Enable VSync

    return true;
}

bool compileShader(string shaderCode, uint type, ref int outShaderId)
{
    // debug writeln("SHADER CODE", shaderCode);
    int shaderId = glCreateShader(type);
    const char* code = shaderCode.toStringz();
    glShaderSource(shaderId, 1, &code, null);
    glCompileShader(shaderId);
    if (!check(shaderId))
    {
        return false;
    }
    debug writeln("Successfully compiled: ", type == GL_VERTEX_SHADER ? "Vertex Shader" : "Frament Shader");
    outShaderId = shaderId;
    return true;

}

private bool check(int shaderId)
{
    int success;

    glGetShaderiv(shaderId, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        debug writeln("FAILED TO COMPILE SHADER !: ", success);
        int logLength;
        glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, &logLength);
        debug writeln("Length of log info: ", logLength);

        if (logLength > 1)
        {
            char[] infoLog = new char[logLength];
            glGetShaderInfoLog(shaderId, logLength, null, cast(char*) infoLog);
            debug writeln("Failed to compile: ", cast(string) infoLog);
        }
        return false;
    }
    return true;
}
