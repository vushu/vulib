module vulib.window.vulkanwindow;
import vulib.window.window;
import std.stdio;
import bindbc.sdl;

class VulkanWindow : Window
{
    SDL_Window* window;
    bool initialize()
    {
        return false;
    }
    
    SDL_Window* getSDLWindow()
    {
        return window;
    }
    
}
