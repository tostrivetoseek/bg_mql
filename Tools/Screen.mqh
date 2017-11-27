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

    CHistogramChart *chartBalances;
    Bot *bots[];

    int init()
    {
        bool Accumulative = true;

        int k=100;
           double arr[10];
        //--- create chart
           CHistogramChart chart;
           if(!chart.CreateBitmapLabel("SampleHistogramChart",10,10,600,250))
             {
              Print("Error creating histogram chart: ",GetLastError());
              return(-1);
             }

           ObjectSetInteger(0, "SampleHistogramChart", OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
           ObjectSetInteger(0, "SampleHistogramChart", OBJPROP_CORNER, CORNER_LEFT_LOWER);

           if(Accumulative)
             {
              chart.Accumulative();
              chart.VScaleParams(20*k*10,/*-10*k*10*/0,20);
             }
           else {
            chart.VScaleParams(20*k,-10*k,20);
           }
           chart.ShowValue(true);
           chart.ShowScaleTop(false);
           chart.ShowScaleBottom(false);
           chart.ShowScaleRight(false);
           chart.ShowLegend();
           for(int j=0;j<5;j++)
             {
              for(int i=0;i<10;i++)
                {
                 k=-k;
                 if(k>0)
                    arr[i]=k*(i+10-j);
                 else
                    arr[i]=k*(i+10-j)/2;
                }
              chart.SeriesAdd(arr,"Item"+IntegerToString(j));
             }
        //--- play with values
           while(!IsStopped())
             {
              int i=rand()%5;
              int j=rand()%10;
              k=rand()%3000-1000;
              chart.ValueUpdate(i,j,k);
              Sleep(200);
             }
        //--- finish
           chart.Destroy();
           return(0);
    }

    void initChartBalances()
    {
        int width = 100 + 10*this.count;
        if (width > 900) {
            width = 900;
        }

        this.chartBalances = new CHistogramChart();
        if ( !this.chartBalances.CreateBitmapLabel(this.name, 10, 10, width, 250) ) {
            delete this.chartBalances;
            this.chartBalances = NULL;
        } else {
            ObjectSetInteger(0, this.name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
            ObjectSetInteger(0, this.name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

            //this.chartBalances.VScaleParams(20*k,-10*k,20);
            this.chartBalances.ShowValue(true);
            this.chartBalances.ShowScaleTop(false);
            this.chartBalances.ShowScaleBottom(false);
            this.chartBalances.ShowScaleRight(false);
            this.chartBalances.ShowLegend();
        }
    }

public:

    Screen(const PBOT &bots[], const string name = "Screen"):
        name(name)
    {
        this.init();
        return;

        this.count = ArraySize(bots);

        ArrayResize(this.bots, this.count);
        ArrayCopy(this.bots, bots);

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

        }
    }
};

#endif