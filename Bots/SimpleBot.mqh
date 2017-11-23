#ifndef BOTS_SIMPLEBOT_MQH
#define BOTS_SIMPLEBOT_MQH

//==================================================

#include "../Base/Bot.mqh"
#include "../Deals/DealArrow.mqh"
#include "../Conditions/ConditionRand.mqh"

//==================================================

class SimpleBot: public Bot
{

public:

    SimpleBot(const string name = NULL):
        Bot(new DealArrowFactory(), new ConditionRand(), new Money(), name)
    {}

    ~SimpleBot()
    {
        delete this.money;
        delete this.condition;
        delete this.dealFactory;
    }
};

#endif