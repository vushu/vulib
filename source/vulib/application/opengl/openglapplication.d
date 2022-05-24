module vulib.application.opengl.openglapplication;
import vulib.application.application;
import vulib.window.opengl.openglwindow;
import vulib.window.window;
import vulib.graphics2d.renderer;
import vulib.graphics2d.opengl.openglrenderer;
import bindbc.sdl;
import std.stdio;
import core.thread.osthread;
import core.time;

class OpenGLApplication : Application
{
private:
    Window _window;
    Renderer _renderer;
    bool _initializedSuccessfully = false;

    ~this()
    {
    }

public:
    void initialize()
    {
        this._window = new OpenGLWindow();

        if (_window.initialize())
        {
            this._renderer = new OpenGLRenderer(this._window);
            _initializedSuccessfully = _renderer.initialize();
        }
    }

    void run()
    {
        if (_initializedSuccessfully)
        {
            debug writeln("Running Game");
            Thread.sleep(dur!("seconds")(2));
        }
        else
        {
            debug writeln("Failed to run Game");
        }
    }
}
