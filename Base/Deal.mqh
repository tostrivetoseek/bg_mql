#ifndef BASE_DEAL_MQH
#define BASE_DEAL_MQH

//==================================================

class Deal
{

public:

    string      symbol;
    int         command;
    double      volume;
    string      comment;
    color       arrowColor;

    Deal():
        comment(NULL),
        arrowColor(clrNONE)
    {
        this.symbol = Symbol();
    }

    virtual int open() = 0;
};

//==================================================

class DealFactory
{

public:

    virtual Deal *create() = 0;
};

#endif