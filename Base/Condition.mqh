#ifndef BASE_CONDITION_MQH
#define BASE_CONDITION_MQH

class Condition
{

private:

    int periodSeconds;
    int randomDelayPeriodsCount;

protected:

    datetime lastDealTime;
    datetime delayUntil;


    datetime getLastBarTime()
    {
        return (datetime)SeriesInfoInteger(Symbol(), 0, SERIES_LASTBAR_DATE);
    }

    bool isOpened()
    {
        return ( this.getLastBarTime() <= this.lastDealTime );
    }

    bool isDelay()
    {
        return ( TimeCurrent() <= this.delayUntil );
    }

public:

    Condition():
        randomDelayPeriodsCount(1)
    {
        this.lastDealTime = this.getLastBarTime();
        this.delayUntil = this.getLastBarTime();

        datetime times[2];
        if ( CopyTime(NULL, 0, 0, 2, times) > 0 ) {
            this.periodSeconds = (int)MathAbs((int)times[1] - (int)times[0]);
        } else {
            this.periodSeconds = 60;
        }
    }

    void setRandomDelayPeriodsCount(const int randomDelayPeriodsCount)
    {
        this.randomDelayPeriodsCount = randomDelayPeriodsCount;
    }

    void setLastDealTime(const datetime time)
    {
        this.lastDealTime = time;
    }

    void setDelay(const int seconds = NULL)
    {
        if (seconds != NULL) {
            this.delayUntil = TimeCurrent() + seconds;
        }

        this.delayUntil = this.getLastBarTime() + this.periodSeconds + MathRand()%(this.periodSeconds*this.randomDelayPeriodsCount);
    }

    virtual int test() = 0;
};

#endif