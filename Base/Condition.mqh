#ifndef BASE_CONDITION_MQH
#define BASE_CONDITION_MQH

class Condition
{

protected:

    datetime lastDealTime;

    datetime getLastBarTime()
    {
        return (datetime)SeriesInfoInteger(Symbol(), 0, SERIES_LASTBAR_DATE);
    }

public:

    Condition()
    {
        this.lastDealTime = this.getLastBarTime();
    }

    void setLastDealTime(datetime time)
    {
        this.lastDealTime = time;
    }

    virtual int test()
    {
        if ( this.getLastBarTime() <= this.lastDealTime ) {
            return 0;
        }

        int point = 100 - MathRand()%201;

        if (point > 50) {
            return 1;
        }

        if (point < -50) {
            return -1;
        }

        return 0;
    }
};

#endif