#ifndef ACCOUNTS_ACCOUNT_GAME_MQH
#define ACCOUNTS_ACCOUNT_GAME_MQH

//==================================================

#include "../Base/Account.mqh"
#include "../Games/Game.mqh"

//==================================================

class AccountGame: public Account
{

protected:

    const int id;

    Game *game;

public:

    AccountGame(const int id, Game *game):
        id(id), game(game)
    {}

    virtual double getBalance()
    {
        return this.game.getPlayerBalance(this.id);
    }

    virtual string open(const int command, const double bet)
    {
        int res;

        if (command > 0) {
            res = this.game.up(this.id, bet);
        } else if (command < 0) {
            res = this.game.down(this.id, bet);
        }

        if (res <= 0) {
            return NULL;
        }

        return "1";
    }
};

#endif