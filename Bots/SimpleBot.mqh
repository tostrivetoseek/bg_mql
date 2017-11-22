#ifndef BOTS_SIMPLEBOT_MQH
#define BOTS_SIMPLEBOT_MQH

//==================================================

#include "../Base/Bot.mqh"

//==================================================

class SimpleBot: public Bot
{

public:

    SimpleBot(const string name = NULL):
        Bot(new DealFactory(), new Condition(), new Money(), name)
    {}

    ~SimpleBot()
    {
        delete this.money;
        delete this.condition;
        delete this.dealFactory;
    }
};

#endif