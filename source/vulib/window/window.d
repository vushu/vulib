module vulib.window.window;
import bindbc.sdl;
interface Window
{
    SDL_Window* getSDLWindow();
    bool initialize();
}
