#ifndef BOTS_BOT_BASIC_MQH
#define BOTS_BOT_BASIC_MQH

//==================================================

#include "../Base/Bot.mqh"

//==================================================

class BotBasic: public Bot
{

protected:

    virtual Deal *getDeal()
    {
        double volume = this.money.getVolume();
        if ( volume <= 0.0 ) {
            return NULL;
        }

        int dir = this.condition.test();
        if ( !dir ) {
            return NULL;
        }

        Deal *deal = this.dealFactory.create();

        deal.command = dir;
        deal.volume = volume;
        deal.arrowColor = dir > 0 ? clrBlue : clrRed;

        if (this.name != NULL) {
            deal.comment = this.name + " " + IntegerToString(deal.command) + " " + DoubleToString(deal.volume, 5);
        }

        return deal;
    }

public:

    BotBasic(DealFactory *dealFactory, Condition *condition, Money *money, const string name = NULL):
        Bot(dealFactory, condition, money, name)
    {}

    virtual void execute()
    {
        Deal *deal = this.getDeal();
        if (deal == NULL) {
            return;
        }

        int id = deal.open();
        if (id) {
            //this.condition.setLastDealTime(TimeCurrent());
            this.condition.setDelay();
        }

        delete deal;
    }
};

#endif