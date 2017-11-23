#property version   "1.00"

//=========================================================

#include "../Bots/BotHA.mqh"

//=========================================================

Bot *bot;

int OnInit()
{
    MathSrand(GetTickCount());

    bot = new BotHA("#1");

    return INIT_SUCCEEDED;
}

void OnTick()
{
    bot.execute();
}

void OnDeinit(const int reason)
{
    delete bot;

    ObjectsDeleteAll(0);

    Print("Deinit reason #", reason);
}