#ifndef CONDITIONS_CONDITION_THREE_MQH
#define CONDITIONS_CONDITION_THREE_MQH

//==================================================

#include "../Base/Condition.mqh"

//==================================================

class ConditionThree: public Condition
{

protected:

    Condition *condition1;
    Condition *condition2;
    Condition *condition3;

public:

    ConditionThree(
        Condition *condition1,
        Condition *condition2,
        Condition *condition3
    ):
        condition1(condition1),
        condition2(condition2),
        condition3(condition3)
    {}

    ~ConditionThree()
    {
        delete this.condition1;
        delete this.condition2;
        delete this.condition3;
    }

    virtual int test()
    {
        if ( this.isDelay() ) {
            return 0;
        }

        if ( this.isOpened() ) {
            return 0;
        }

        if (this.condition1.test() > 0 && this.condition2.test() > 0 && this.condition3.test() > 0) {
            return 1;
        }

        if (this.condition1.test() < 0 && this.condition2.test() < 0 && this.condition3.test() < 0) {
            return -1;
        }

        return 0;
    }
};

#endif