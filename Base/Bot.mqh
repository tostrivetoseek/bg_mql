#ifndef BASE_BOT_MQH
#define BASE_BOT_MQH

//==================================================

#include "Deal.mqh"
#include "Condition.mqh"
#include "Money.mqh"

//==================================================

class Bot
{

protected:

    DealFactory     *dealFactory;
    Condition       *condition;
    Money           *money;

    const string    name;


    virtual Deal *getDeal()
    {
        int dir = this.condition.test();
        if ( !dir ) {
            return NULL;
        }

        Deal *deal = this.dealFactory.create();

        deal.command = dir;
        deal.volume = this.money.volume();
        deal.arrowColor = dir > 0 ? clrBlue : clrRed;

        if (this.name != NULL) {
            deal.comment = "#" + this.name;
        }

        return deal;
    }

public:

    Bot(DealFactory *dealFactory, Condition *condition, Money *money, const string name = NULL):
        dealFactory(dealFactory), condition(condition), money(money),
        name(name)
    {}

    virtual void execute()
    {
        Deal *deal = this.getDeal();
        if (deal == NULL) {
            return;
        }

        deal.open();

        delete deal;
    }
};

#endif