#property version   "1.00"

input double            I_StartBalance = 100.0;         // Start balance
input double            I_SystemPercent = 0.0;          // System percent
input bool              I_UseScreen = true;             // Use screen

//=========================================================

#include "Accounts/AccountGame.mqh"
#include "Deals/DealExternal.mqh"
#include "Money/MoneyStandartExternal.mqh"
#include "Bots/BotModel.mqh"
#include "Games/Game.mqh"
#include "Tools/Screen.mqh"

#include "Conditions/ConditionRand.mqh"
#include "Conditions/ConditionHA.mqh"
#include "Conditions/ConditionMA.mqh"
#include "Conditions/ConditionStoch.mqh"
#include "Conditions/ConditionThree.mqh"

//=========================================================

Account *accounts[];
Bot *bots[];
Game *game;
Screen *screen;

int botsCount;

void addGameBot(const string name, Condition *condition, Game *game)
{
    ArrayResize(bots, botsCount + 1);
    ArrayResize(accounts, botsCount + 1);

    Account *account = new AccountGame(game.register(I_StartBalance), game);
    accounts[botsCount] = account;

    bots[botsCount] = new BotModel(
        new DealExternalFactory(account),
        condition,
        new MoneyStandartExternal(account),
        name
    );

    ++botsCount;
}

int OnInit()
{
    MathSrand(GetTickCount());

    botsCount = 0;

    ArrayResize(bots, botsCount + 1);
    ArrayResize(accounts, botsCount + 1);
    game = new Game(I_SystemPercent);
    bots[botsCount] = game;
    accounts[botsCount] = NULL;
    ++botsCount;

    addGameBot("Rand", new ConditionRand(), game);
    addGameBot("Rand", new ConditionRand(), game);
    addGameBot("HA", new ConditionHA(), game);
    addGameBot("HA5", new ConditionHA(PERIOD_M5), game);
    addGameBot("MA(13)", new ConditionMA(13), game);
    addGameBot("MA(21)", new ConditionMA(21), game);
    addGameBot("MA(34)", new ConditionMA(34), game);
    addGameBot("MA(55)", new ConditionMA(55), game);
    addGameBot("Stoch(8)", new ConditionStoch(8), game);
    addGameBot("Stoch(13)", new ConditionStoch(13), game);
    addGameBot("Stoch(21)", new ConditionStoch(21), game);
    addGameBot("Stoch(34)", new ConditionStoch(34), game);

    addGameBot(
        "Three",
        new ConditionThree(
            new ConditionHA(PERIOD_M5),
            new ConditionMA(55),
            new ConditionStoch(34)
        ),
        game
    );

    if (I_UseScreen) {
        screen = new Screen(bots);
    } else {
        screen = NULL;
    }

    return INIT_SUCCEEDED;
}

void OnTick()
{
    for (int i = 0; i < botsCount; ++i) {
        bots[i].execute();
    }

    screen.execute();
}

void OnDeinit(const int reason)
{
    if (screen != NULL) {
        delete screen;
    }

    for (int i = 0; i < botsCount; ++i) {
        delete bots[i];

        if (accounts[i] != NULL) {
            delete accounts[i];
        }
    }

    Print("Deinit reason #", reason);
}