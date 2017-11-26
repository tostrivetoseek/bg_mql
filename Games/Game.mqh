#ifndef GAMES_GAME_MQH
#define GAMES_GAME_MQH

//==================================================

#include "../Base/Bot.mqh"

//==================================================

class Round
{

protected:

    const datetime time;
    const int playersCount;

    double percent;
    double winPart;

    int upCount;
    int downCount;
    double upTotal;
    double downTotal;

    string drawPrefix;

    void deleteObjects()
    {
        ObjectsDeleteAll(0, this.drawPrefix);
    }

    void distr(const double money, const double winTotal, double &winners[], double &playerBalances[], double &systemBalance)
    {
        if (money <= 0.0 || winTotal <= 0.0) {
            return;
        }

        double rest = money;

        for (int i = 0; i < this.playersCount; ++i) {
            if (winners[i] <= 0.0) {
                continue;
            }

            double profit = winners[i]*money*this.winPart/winTotal;
            profit = (int)(profit*10000)/10000.0;

            playerBalances[i] += winners[i] + profit;

            rest -= profit;
        }

        systemBalance += rest;
    }

    bool drawLabel(const string text, const int type, const datetime time, const double price)
    {
        string name;
        ENUM_ANCHOR_POINT anchor;
        color clr;

        if (type > 0) {
            name = this.drawPrefix + "U";
            if ( time == this.getTime() ) {
                anchor = ANCHOR_LOWER;
            } else {
                anchor = ANCHOR_LEFT_LOWER;
            }
            clr = clrGreen;
        } else {
            name = this.drawPrefix + "D";
            if ( time == this.getTime() ) {
                anchor = ANCHOR_UPPER;
            } else {
                anchor = ANCHOR_LEFT_UPPER;
            }
            clr = clrRed;
        }

        if ( !ObjectCreate(0, name, OBJ_TEXT, 0, time, price) ) {
            return false;
        }

        ObjectSetString(0, name, OBJPROP_TEXT, text);
        ObjectSetString(0, name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 10);
        ObjectSetInteger(0, name, OBJPROP_ANCHOR, anchor);
        ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
        ObjectSetInteger(0, name, OBJPROP_BACK, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

        return true;
    }

public:

    // по-другому не получить доступ к инкапсулированным массивам
    double upBets[];
    double downBets[];


    Round(const datetime time, const double percent, const int playersCount):
        time(time), percent(percent), playersCount(playersCount),
        upCount(0), downCount(0), upTotal(0.0), downTotal(0.0)
    {
        if (this.percent > 100.0) {
            this.percent = 100.0;
        } else if (this.percent < 0.0) {
            this.percent = 0.0;
        }

        this.winPart = 1.0 - this.percent/100.0;

        this.drawPrefix = "Round " + TimeToString(this.time) + " ";

        ArrayResize(this.upBets, this.playersCount);
        ArrayInitialize(this.upBets, 0.0);

        ArrayResize(this.downBets, this.playersCount);
        ArrayInitialize(this.downBets, 0.0);
    }

    ~Round()
    {
        this.deleteObjects();
    }

    datetime getTime()
    {
        return this.time;
    }

    int up(const int id, const double bet)
    {
        if (id >= this.playersCount) {
            return -1;
        }

        if (this.upBets[id] <= 0.0 && this.upBets[id] + bet > 0.0) {
            ++this.upCount;
        }

        this.upBets[id] += bet;
        this.upTotal += bet;

        return 1;
    }

    int down(const int id, const double bet)
    {
        if (id >= this.playersCount) {
            return -1;
        }

        if (this.downBets[id] <= 0.0 && this.downBets[id] + bet > 0.0) {
            ++this.downCount;
        }

        this.downBets[id] += bet;
        this.downTotal += bet;

        return 1;
    }

    void play(double &playerBalances[], double &systemBalance)
    {
        bool cancel = false;

        if (this.upTotal <= 0.0 || this.downTotal <= 0.0) {
            cancel = true;
        }

        if (!cancel) {
            datetime times[1];
            if ( CopyTime(NULL, 0, 1, 1, times) > 0 ) {
                if ( times[0] != this.getTime() ) {
                    cancel = true;
                }
            } else {
                cancel = true;
            }
        }

        double open[1];
        if (!cancel) {
            if ( CopyOpen(NULL, 0, 1, 1, open) <= 0 ) {
                cancel = true;
            }
        }

        double close[1];
        if (!cancel) {
            if ( CopyClose(NULL, 0, 1, 1, close) <= 0 ) {
                cancel = true;
            }
        }

        if (!cancel) {
            if ( MathAbs(close[0] - open[0]) < Point() ) {
                cancel = true;
            }
        }

        if (cancel) {
            for (int i = 0; i < this.playersCount; ++i) {
                if (this.upBets[i] > 0.0) {
                    playerBalances[i] += this.upBets[i];
                }
                if (this.downBets[i] > 0.0) {
                    playerBalances[i] += this.downBets[i];
                }
            }

            return;
        }

        if (close[0] > open[0]) {
            this.distr(this.downTotal, this.upTotal, this.upBets, playerBalances, systemBalance);
        } else {
            this.distr(this.upTotal, this.downTotal, this.downBets, playerBalances, systemBalance);
        }
    }

    void draw(const int timeShift = 0)
    {
        double high[1];
        if ( CopyHigh(NULL, 0, 0, 1, high) <= 0 ) {
            return;
        }

        double low[1];
        if ( CopyLow(NULL, 0, 0, 1, low) <= 0 ) {
            return;
        }

        this.deleteObjects();

        double priceShift = 0.0;
        if ( timeShift > 0 && high[0] - low[0] > Point() ) {
            priceShift = NormalizeDouble((high[0] - low[0])/2.0, Digits()) - Point();
            if (priceShift < 0.0) {
                priceShift = 0.0;
            }
        }

        this.drawLabel(
            "U " + IntegerToString(this.upCount) + ": " + DoubleToString(this.upTotal, 4),
            1,
            this.getTime() + timeShift,
            high[0] - priceShift
        );
        this.drawLabel(
            "D " + IntegerToString(this.downCount) + ": " + DoubleToString(this.downTotal, 4),
            -1,
            this.getTime() + timeShift,
            low[0] + priceShift
        );
    }
};

//==================================================

class Game: public Bot
{

private:

    int periodSeconds;

protected:

    const double percent;

    double balance;

    int playersCount;
    double playerBalances[];

    Round *currentRound;
    Round *nextRound;


    virtual Deal *getDeal()
    {
        return NULL;
    }

    datetime getLastBarTime()
    {
        return (datetime)SeriesInfoInteger(Symbol(), 0, SERIES_LASTBAR_DATE);
    }

public:

    Game(const double percent = 0.0, const string name = "System"):
        Bot(NULL, NULL, NULL, name),
        percent(percent),
        balance(0.0), playersCount(0),
        currentRound(NULL), nextRound(NULL)
    {
        datetime times[2];
        if ( CopyTime(NULL, 0, 0, 2, times) > 0 ) {
            this.periodSeconds = (int)MathAbs((int)times[1] - (int)times[0]);
        } else {
            this.periodSeconds = 60;
        }
    }

    ~Game()
    {
        if (this.nextRound != NULL) {
            delete this.nextRound;
        }
        if (this.currentRound != NULL) {
            this.currentRound.play(this.playerBalances, this.balance);
            delete this.currentRound;
        }
    }

    virtual double getBalance()
    {
        return this.balance;
    }

    Round *getCurrentRound()
    {
        return this.currentRound;
    }

    Round *getNextRound()
    {
        return this.nextRound;
    }

    int register(double balance)
    {
        if (balance < 0.0) {
            balance = 0.0;
        }

        int id = this.playersCount;

        ++this.playersCount;

        ArrayResize(this.playerBalances, this.playersCount); // неэффективно, но вызываем только в начале игры

        this.playerBalances[id] = balance;

        return id;
    }

    int up(const int id, const double bet)
    {
        if (id >= this.playersCount) {
            return -1;
        }

        if (bet > this.playerBalances[id]) {
            return -2;
        }

        if (this.nextRound == NULL) {
            return -3;
        }

        if ( this.nextRound.up(id, bet) < 0 ) {
            return -4;
        }

        this.playerBalances[id] -= bet;

        return 1;
    }

    int down(const int id, const double bet)
    {
        if (id >= this.playersCount) {
            return -1;
        }

        if (bet > this.playerBalances[id]) {
            return -2;
        }

        if (this.nextRound == NULL) {
            return -3;
        }

        if ( this.nextRound.down(id, bet) < 0 ) {
            return -4;
        }

        this.playerBalances[id] -= bet;

        return 1;
    }

    double getPlayerBalance(const int id)
    {
        if (id >= this.playersCount) {
            return 0.0;
        }

        return this.playerBalances[id];
    }

    virtual void execute()
    {
        if (this.currentRound == NULL) {
            this.currentRound = new Round(this.getLastBarTime(), this.percent, this.playersCount);
        }
        if (this.nextRound == NULL) {
            this.nextRound = new Round(this.currentRound.getTime() + this.periodSeconds, this.percent, this.playersCount);
        }

        if ( this.nextRound.getTime() <= this.getLastBarTime() ) {
            this.currentRound.play(this.playerBalances, this.balance);
            delete this.currentRound;

            this.currentRound = this.nextRound;

            this.nextRound = new Round(this.currentRound.getTime() + this.periodSeconds, this.percent, this.playersCount);
        }

        this.currentRound.draw();
        this.nextRound.draw(5*this.periodSeconds);
    }
};

#endif