//
//  FirstViewController.h
//  iPhoneBitcoin
//
//  Created by Jeremias Kangas on 2/18/11.
//  Copyright 2011 Kangas Bros. Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface MarketDepthViewController : UIViewController  <CPPlotDataSource>
{
	IBOutlet CPGraphHostingView *hostingView;
	CPXYGraph *graph;
	int minX;
	int maxX;
	float minY;
	float maxY;
};

@property (nonatomic, retain) IBOutlet CPGraphHostingView *hostingView;
@property (nonatomic, retain) IBOutlet CPXYGraph *graph;
- (void)refreshChart2;

@end
