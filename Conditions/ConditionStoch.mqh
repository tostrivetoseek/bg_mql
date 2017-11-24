#ifndef CONDITIONS_CONDITION_STOCH_MQH
#define CONDITIONS_CONDITION_STOCH_MQH

//==================================================

#include "../Base/Condition.mqh"

//==================================================

class ConditionStoch: public Condition
{

protected:

    int handle;

public:

    ConditionStoch(
        const int Kperiod,
        const int Dperiod = 3,
        const int slowing = 3,
        const ENUM_MA_METHOD maMethod = MODE_SMA,
        const ENUM_STO_PRICE priceField = STO_LOWHIGH,
        const ENUM_TIMEFRAMES timeframe = 0
    )
    {
        this.handle = iStochastic(NULL, timeframe, Kperiod, Dperiod, slowing, maMethod, priceField);
    }

    ~ConditionStoch()
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
        double signal[1];

        if ( CopyBuffer(this.handle, 0, 1, 1, value) <= 0 ) {
            return 0;
        }
        if ( CopyBuffer(this.handle, 1, 1, 1, signal) <= 0 ) {
            return 0;
        }

        if (value[0] > signal[0]) {
            return 1;
        }

        if (value[0] < signal[0]) {
            return -1;
        }

        return 0;
    }
};

#endif