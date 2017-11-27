#ifndef MONEY_MONEY_STANDART_MQH
#define MONEY_MONEY_STANDART_MQH

//==================================================

#include "../Base/Money.mqh"

//==================================================

class MoneyStandart: public Money
{

public:

    virtual double getVolume()
    {
        if ( 1.0 > this.getBalance() ) {
            return 0.0;
        }

        return 1.0;
    }

};

#endif