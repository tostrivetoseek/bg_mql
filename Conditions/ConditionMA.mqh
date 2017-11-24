#ifndef CONDITIONS_CONDITION_MA_MQH
#define CONDITIONS_CONDITION_MA_MQH

//==================================================

#include "../Base/Condition.mqh"

//==================================================

class ConditionMA: public Condition
{

protected:

    const ENUM_TIMEFRAMES timeframe;

    int handle;

public:

    ConditionMA(
        const int period,
        const int shift = 0,
        const ENUM_MA_METHOD method = MODE_SMA,
        const ENUM_APPLIED_PRICE appliedPrice = PRICE_CLOSE,
        const ENUM_TIMEFRAMES timeframe = 0
    ):
        timeframe(timeframe)
    {
        this.handle = iMA(NULL, this.timeframe, period, shift, method, appliedPrice);
    }

    ~ConditionMA()
    {
        IndicatorRelease(this.handle);
    }

    virtual int test()
    {
        if (this.handle == INVALID_HANDLE) {
            return 0;
        }

        if ( this.isDelay() ) {
            return 0;
        }

        if ( this.isOpened() ) {
            return 0;
        }

        double value[1];
        double close[1];

        if ( CopyBuffer(this.handle, 0, 1, 1, value) <= 0 ) {
            return 0;
        }
        if ( CopyClose(NULL, this.timeframe, 1, 1, close) <= 0 ) {
            return 0;
        }

        if (close[0] > value[0]) {
            return 1;
        }

        if (close[0] < value[0]) {
            return -1;
        }

        return 0;
    }
};

#endif