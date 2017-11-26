#ifndef MONEY_MONEY_STANDART_EXTERNAL_MQH
#define MONEY_MONEY_STANDART_EXTERNAL_MQH

//==================================================

#include "MoneyStandart.mqh"
#include "../Base/Account.mqh"

//==================================================

class MoneyStandartExternal: public MoneyStandart
{

protected:

    Account *account;

public:

    MoneyStandartExternal(Account *account):
        account(account)
    {}

    virtual double getBalance()
    {
        return this.account.getBalance();
    }
};

#endif