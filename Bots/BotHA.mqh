#ifndef BOTS_BOT_HA_MQH
#define BOTS_BOT_HA_MQH

//==================================================

#include "../Base/Bot.mqh"
#include "../Deals/DealArrow.mqh"
#include "../Conditions/ConditionHA.mqh"

//==================================================

class BotHA: public Bot
{

public:

    BotHA(const string name = NULL):
        Bot(new DealArrowFactory(), new ConditionHA(), new Money(), "BotHA " + name)
    {}

    ~BotHA()
    {
        delete this.money;
        delete this.condition;
        delete this.dealFactory;
    }
};

#endif