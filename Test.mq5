#property version   "1.00"

//=========================================================

#include "Games/Game.mqh"

//=========================================================

void OnStart()
{
    Game *game = new Game();

    for (int i = 0; i < 10; ++i) {
        game.register(0.5*i);
    }

    for (int i = 0; i < 12; ++i) {
        Print( DoubleToString(game.getPlayerBalance(i)) );
    }

    delete game;
}