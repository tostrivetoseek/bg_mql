#property version   "1.00"

//=========================================================

#include "../Bots/SimpleBot.mqh"

//=========================================================

Bot *bot;

int OnInit()
{
    bot = new SimpleBot("1");

    return INIT_SUCCEEDED;
}

void OnTick()
{
    bot.execute();
}

void OnDeinit(const int reason)
{
    delete bot;

    Print("Deinit reason #", reason);
}