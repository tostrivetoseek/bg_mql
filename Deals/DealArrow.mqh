#ifndef DEALS_DEAL_ARROW_MQH
#define DEALS_DEAL_ARROW_MQH

//==================================================

#include "../Base/Deal.mqh"

//==================================================

class DealArrow: public Deal
{

protected:

    bool drawArrow(const string name, const ENUM_OBJECT type, const datetime time, const double price)
    {
        if ( !ObjectCreate(0, name, type, 0, time, price) ) {
            return false;
        }

        ObjectSetInteger(0, name, OBJPROP_COLOR, this.arrowColor);
        ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
        ObjectSetInteger(0, name, OBJPROP_BACK, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

        return true;
    }

public:

    virtual int open()
    {
        if ( this.command == 0 ) {
            return 0;
        }

        if ( this.volume <= 0.0 ) {
            return 0;
        }

        if ( this.arrowColor == clrNONE ) {
            return 0;
        }

        string name = IntegerToString(MathRand())
            + " "
            + TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS);

        ENUM_OBJECT type = this.command > 0 ? OBJ_ARROW_BUY : OBJ_ARROW_SELL;

        double price = SymbolInfoDouble(this.symbol, SYMBOL_BID);

        if ( !this.drawArrow(name, type, TimeCurrent(), price) ) {
            return 0;
        }

        if (this.comment != NULL) {
            Print(this.comment);
        }

        return 1;
    }
};

//==================================================

class DealArrowFactory: public DealFactory
{

public:

    virtual Deal *create()
    {
        return new DealArrow();
    }
};

#endif