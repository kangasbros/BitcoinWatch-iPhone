//
//  FirstViewController.h
//  iPhoneBitcoin
//
//  Created by Jeremias Kangas on 2/18/11.
//  Copyright 2011 Kangas Bros. Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface FirstViewController : UIViewController  <CPPlotDataSource>
{
	IBOutlet CPGraphHostingView *hostingView;
	IBOutlet UILabel *labelLast;
	IBOutlet UILabel *labelVolume;
	IBOutlet UILabel *labelHigh;
	IBOutlet UILabel *labelLow;
	IBOutlet UILabel *labelSell;
	IBOutlet UILabel *labelBuy;
	IBOutlet UILabel *labelLastRefresh;
	CPXYGraph *graph;
	int numValues;
	NSMutableArray *values;
	int minX;
	int maxX;
	float minY;
	float maxY;
};

@property (nonatomic, retain) IBOutlet CPGraphHostingView *hostingView;
@property (nonatomic, retain) IBOutlet UILabel *labelLast;
@property (nonatomic, retain) IBOutlet UILabel *labelHigh;
- (void)refreshChart;

@end
