#ifndef BOTS_BOT_MODEL_MQH
#define BOTS_BOT_MODEL_MQH

//==================================================

#include "BotBasic.mqh"

//==================================================

class BotModel: public BotBasic
{

public:

    BotModel(DealFactory *dealFactory, Condition *condition, Money *money, const string name = NULL):
        BotBasic(dealFactory, condition, money, name)
    {}

    ~BotModel()
    {
        delete this.money;
        delete this.condition;
        delete this.dealFactory;
    }
};

#endif