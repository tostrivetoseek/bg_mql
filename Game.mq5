#property version   "1.00"

//=========================================================

#include "Tools/Screen.mqh"

//=========================================================

Screen *screen;

int OnInit()
{
    MathSrand(GetTickCount());

    screen = new Screen();

    return INIT_SUCCEEDED;
}

void OnTick()
{

}

void OnDeinit(const int reason)
{
    delete screen;

    Print("Deinit reason #", reason);
}