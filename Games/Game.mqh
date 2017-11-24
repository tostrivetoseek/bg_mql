#ifndef GAMES_GAME_MQH
#define GAMES_GAME_MQH

//==================================================

#include "../Base/Bot.mqh"

//==================================================

class Round
{

protected:

    const datetime time;
    const double percent;
    const int playersCount;

    string drawPrefix;

    double upBets[];
    double downBets[];

    void deleteObjects()
    {
        ObjectsDeleteAll(0, this.drawPrefix);
    }

public:

    Round(const datetime time, const double percent, const int playersCount):
        time(time), percent(percent), playersCount(playersCount)
    {
        this.drawPrefix = "Round " + TimeToString(this.time);

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

        this.upBets[id] += bet;

        return 1;
    }

    int down(const int id, const double bet)
    {
        if (id >= this.playersCount) {
            return -1;
        }

        this.downBets[id] += bet;

        return 1;
    }

    void play(double &playerBalances[], double &systemBalance)
    {

    }

    void draw()
    {

    }
}

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

    Game(const double percent = 0.0, const string name = "TheGame"):
        Bot(NULL, NULL, NULL, name),
        percent(percent),
        balance(0.0), playersCount(0)
    {
        datetime times[2];
        if ( CopyTime(NULL, 0, 0, 2, times) > 0 ) {
            this.periodSeconds = MathAbs((int)times[1] - (int)times[0]);
        } else {
            this.periodSeconds = 60;
        }

        this.currentRound = new Round(this.getLastBarTime(), this.percent);
        this.nextRound = new Round(this.currentRound.getTime() + this.periodSeconds, this.percent);
    }

    ~Game()
    {
        delete this.currentRound;
        delete this.nextRound;
    }

    virtual double getBalance()
    {
        return this.balance;
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

        if ( this.nextRound.up(id, bet) < 0) {
            return -3;
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

        if ( this.nextRound.down(id, bet) < 0) {
            return -3;
        }

        this.playerBalances[id] -= bet;

        return 1;
    }

    double getPlayerBalance(const int id)
    {
        if (id >= this.playersCount) {
            Print("Unknown player id " + IntegerToString(id));
            return 0.0;
        }

        return this.playerBalances[id];
    }

    virtual void execute()
    {
        if ( this.nextRound.getTime() <= this.getLastBarTime() ) {
            this.currentRound.play(this.playerBalances, this.balance);
            delete this.currentRound();

            this.currentRound = this.nextRound;

            this.nextRound = new Round(this.currentRound.getTime() + this.periodSeconds, this.percent, this.playersCount);
        }

        this.currentRound.draw();
        this.nextRound.draw();
    }
};

#endif