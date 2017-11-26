#ifndef DEALS_DEAL_EXTERNAL_MQH
#define DEALS_DEAL_EXTERNAL_MQH

//==================================================

#include "../Base/Deal.mqh"
#include "../Base/Account.mqh"

//==================================================

class DealExternal: public Deal
{

protected:

    Account *account;

public:

    DealExternal(Account *account):
        account(account)
    {}

    virtual int open()
    {
        if ( this.command == 0 ) {
            return 0;
        }

        if ( this.volume <= 0.0 ) {
            return 0;
        }

        string res = this.account.open(this.command, this.volume);
        if (res == NULL) {
            return 0;
        }

        int id = StringToInteger(res);
        if (id <= 0) {
            return 0;
        }

        if (this.comment != NULL) {
            Print(this.comment);
        }

        return id;
    }
};

//==================================================

class DealExternalFactory: public DealFactory
{

protected:

    Account *account;

public:

    DealExternalFactory(Account *account):
        account(account)
    {}

    virtual Deal *create()
    {
        return new DealExternal(this.account);
    }
};

#endif