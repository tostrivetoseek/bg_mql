#ifndef CONDITIONS_CONDITION_HA_MQH
#define CONDITIONS_CONDITION_HA_MQH

//==================================================

#include "../Base/Condition.mqh"

//==================================================

class ConditionHA: public Condition
{

protected:

    int handle;

public:

    ConditionHA(const int randomDelayPeriodsCount = 1):
        Condition(randomDelayPeriodsCount)
    {
        this.handle = iCustom(NULL, 0, "Examples\\Heiken_Ashi");
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

        double open[1];
        double close[1];

        if ( CopyBuffer(this.handle, 0, 1, 1, open) <= 0 ) {
            return 0;
        }
        if ( CopyBuffer(this.handle, 3, 1, 1, close) <= 0 ) {
            return 0;
        }

        if (close[0] > open[0]) {
            return 1;
        }

        if (close[0] < open[0]) {
            return -1;
        }

        return 0;
    }
};

#endif