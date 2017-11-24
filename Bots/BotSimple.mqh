#ifndef BOTS_BOT_SIMPLE_MQH
#define BOTS_BOT_SIMPLE_MQH

//==================================================

#include "BotBasic.mqh"
#include "../Deals/DealArrow.mqh"
#include "../Conditions/ConditionStoch.mqh"

//==================================================

class BotSimple: public BotBasic
{

public:

    BotSimple(const string name = NULL):
        BotBasic(new DealArrowFactory(), new ConditionStoch(8), new Money(), "BotSimple" + ( name == NULL ? "" : " " + name ))
    {}

    ~BotSimple()
    {
        delete this.money;
        delete this.condition;
        delete this.dealFactory;
    }
};

#endif