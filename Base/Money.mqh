#ifndef BASE_MONEY_MQH
#define BASE_MONEY_MQH

class Money
{

public:

    virtual double volume()
    {
        return 1.0;
    }
};

#endif