#ifndef BASE_MONEY_MQH
#define BASE_MONEY_MQH

class Money
{

public:

    virtual double getVolume()
    {
        return 1.0;
    }

    virtual double getBalance()
    {
        return 0.0;
    }
};

#endif