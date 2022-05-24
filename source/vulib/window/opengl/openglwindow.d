module vulib.window.opengl.openglwindow;
import vulib.window.window;
import std.stdio;
import bindbc.sdl;
import bindbc.sdl.image;
import bindbc.opengl;
import std.string : fromStringz;
import std.conv;
import std.typecons;
import core.stdc.stdlib;
import vulib.graphics2d.opengl.glhelper : setupOpengl, makeOpenGLContext;

class OpenGLWindow : Window
{

public:

    this()
    {
    }

    bool initialize()
    {
        loadSDLLibrary();
        if (initializeSDL() && initializeSDLImage())
        {
            setupOpengl();
            initializedSuccessfully =  createWindow() && makeOpenGLContext(_window, _glContext);
        }
        return initializedSuccessfully;
    }

    ~this()
    {
        if (initializedSuccessfully)
        {
            // debug writeln("Calling destroying: ");
            // debug writeln("***************");
            // debug writeln("SDL\n", "OpenGL Context\n", "SDL_Quit\n", "IMG_Quit\n");
            SDL_DestroyWindow(_window);
            SDL_GL_DeleteContext(_glContext);
            SDL_Quit();
            IMG_Quit();
            // debug writeln("***************");
        }
        else
        {
            // debug writeln("Called destructor but nothing is destroyed");
        }
    }

    SDL_Window* getSDLWindow()
    {
        return _window;
    }

private:

    bool initializedSuccessfully = false;
    SDL_Window* _window;
    SDL_GLContext _glContext;
    void loadSDLLibrary()
    {
        const SDLSupport ret = loadSDL();
        if (ret != sdlSupport)
        {
            SDL_Log("Error loading SDL dll");
            return;
        }

        if (loadSDLImage() != sdlImageSupport)
        {
            SDL_Log("Error loading SDL Image dll %s", SDL_GetError());
            return;
        }
    }

    @nogc bool initializeSDLImage()
    {
        const flags = IMG_INIT_PNG | IMG_INIT_JPG;
        if ((IMG_Init(flags) & flags) != flags)
        {
            SDL_Log("IMG_Init: %s", IMG_GetError());
            return false;
        }
        return true;
    }

    @nogc bool initializeSDL()
    {
        if (SDL_Init(SDL_INIT_VIDEO) != 0)
        {
            debug writeln("Failed to initialize loading SDL Image dll ", to!string(SDL_GetError()));
            return false;
        }
        return true;
    }

    bool createWindow()
    {
        const windowFlags = SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE
            | SDL_WINDOW_ALLOW_HIGHDPI | SDL_WINDOW_SHOWN;
        _window = SDL_CreateWindow("Vulib Window", SDL_WINDOWPOS_UNDEFINED,
            SDL_WINDOWPOS_UNDEFINED, 800, 600, windowFlags);

        if (_window is null)
        {
            debug writefln("SDL_CreateWindow: ", SDL_GetError());
            return false;
        }
        return true;
    }

}
