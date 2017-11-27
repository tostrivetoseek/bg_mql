#ifndef TOOLS_SCREEN_MQH
#define TOOLS_SCREEN_MQH

//==================================================

#include <Canvas\Charts\HistogramChart.mqh>
#include "../Base/Bot.mqh"

//==================================================

class Screen
{

protected:

    const string name;

    int count;
    double moneyTotal;

    CHistogramChart *chartBalances;
    Bot *bots[];

    void initChartBalances()
    {
        int width = 100 + 10*this.count;
        if (width > 900) {
            width = 900;
        }

        this.chartBalances = new CHistogramChart();
        if ( !this.chartBalances.CreateBitmapLabel(this.name, 10, 10, width, 300) ) {
            delete this.chartBalances;
            this.chartBalances = NULL;
        } else {
            ObjectSetInteger(0, this.name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
            ObjectSetInteger(0, this.name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

            double maxBalance = this.getMaxBalance();
            double heightScale = this.moneyTotal;
            if (heightScale > 50*maxBalance) {
                heightScale = 50*maxBalance;
            }

            this.chartBalances.VScaleParams(heightScale, 0, 10);

            this.chartBalances.ShowValue(true);
            this.chartBalances.ShowScaleTop(false);
            this.chartBalances.ShowScaleBottom(false);
            this.chartBalances.ShowScaleRight(false);
            this.chartBalances.BarBorder(true);
            this.chartBalances.ShowLegend(false);

            double v[];
            ArrayResize(v, this.count);
            for (int i = 0; i < this.count; ++i) {
                v[i] = this.bots[i].getBalance();
            }
            this.chartBalances.SeriesAdd(v, "Balances", clrGreen);
        }
    }

    double getMaxBalance()
    {
        double max = this.bots[0].getBalance();

        for (int i = 1; i < this.count; ++i) {
            if (this.bots[i].getBalance() > max) {
                max = this.bots[i].getBalance();
            }
        }

        return max;
    }

    double getSumBalances()
    {
        double sum = 0.0;

        for (int i = 0; i < this.count; ++i) {
            sum += this.bots[i].getBalance();
        }

        return sum;
    }

public:

    Screen(const PBOT &bots[], const string name = "Screen"):
        name(name)
    {
        this.count = ArraySize(bots);

        ArrayResize(this.bots, this.count);
        ArrayCopy(this.bots, bots);

        this.moneyTotal = this.getSumBalances();

        this.initChartBalances();
    }

    ~Screen()
    {
        if (this.chartBalances != NULL) {
            this.chartBalances.Destroy();
            delete this.chartBalances;
        }
    }

    void execute()
    {
        if (this.chartBalances != NULL) {
            double v[];
            ArrayResize(v, this.count);
            for (int i = 0; i < this.count; ++i) {
                v[i] = this.bots[i].getBalance();
            }
            this.chartBalances.SeriesUpdate(0, v);
        }
    }
};

#endif