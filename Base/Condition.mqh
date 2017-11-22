#ifndef BASE_CONDITION_MQH
#define BASE_CONDITION_MQH

class Condition
{

public:

    virtual int test()
    {
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