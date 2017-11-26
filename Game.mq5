#property version   "1.00"

//=========================================================

#include "Games/Game.mqh"

//=========================================================

Game *game;

int OnInit()
{
    MathSrand(GetTickCount());

    game = new Game();

    return INIT_SUCCEEDED;
}

void OnTick()
{
    game.execute();
}

void OnDeinit(const int reason)
{
    delete game;

    Print("Deinit reason #", reason);
}