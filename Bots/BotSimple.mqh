#ifndef BOTS_BOT_SIMPLE_MQH
#define BOTS_BOT_SIMPLE_MQH

//==================================================

#include "../Base/Bot.mqh"
#include "../Deals/DealArrow.mqh"
#include "../Conditions/ConditionRand.mqh"

//==================================================

class BotSimple: public Bot
{

public:

    BotSimple(const string name = NULL):
        Bot(new DealArrowFactory(), new ConditionRand(), new Money(), "BotSimple " + name)
    {}

    ~BotSimple()
    {
        delete this.money;
        delete this.condition;
        delete this.dealFactory;
    }
};

#endif