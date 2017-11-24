#ifndef CONDITIONS_CONDITION_RAND_MQH
#define CONDITIONS_CONDITION_RAND_MQH

//==================================================

#include "../Base/Condition.mqh"

//==================================================

class ConditionRand: public Condition
{

public:

    virtual int test()
    {
        if ( this.isDelay() ) {
            return 0;
        }

        if ( this.isOpened() ) {
            return 0;
        }

        int point = 100 - MathRand()%201;

        if (point > 0) {
            return 1;
        }

        if (point < 0) {
            return -1;
        }

        return 0;
    }
};

#endif