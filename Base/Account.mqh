#ifndef BASE_ACCOUNT_MQH
#define BASE_ACCOUNT_MQH

class Account
{

public:

    virtual double getBalance() = 0;

    virtual string open(const int command, const double bet) = 0;
};

#endif