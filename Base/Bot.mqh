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

    virtual Deal *getDeal() = 0;

public:

    Bot(DealFactory *dealFactory, Condition *condition, Money *money, const string name = NULL):
        dealFactory(dealFactory),
        condition(condition),
        money(money),
        name(name)
    {}

    virtual void execute()
    {
        Deal *deal = this.getDeal();
        if (deal == NULL) {
            return;
        }

        int id = deal.open();
        if (id) {
            this.condition.setLastDealTime(TimeCurrent());
        }

        delete deal;
    }

    virtual double getBalance()
    {
        return this.money.getBalance();
    }

    string getName()
    {
        return this.name;
    }
};

#endif