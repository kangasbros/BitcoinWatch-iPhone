//
//  FirstViewController.m
//  iPhoneBitcoin
//
//  Created by Jeremias Kangas on 2/18/11.
//  Copyright 2011 Kangas Bros. Innovations. All rights reserved.
//

#import "MarketDepthViewController.h"
#import "iPhoneBitcoinAppDelegate.h"


@implementation MarketDepthViewController

@synthesize hostingView, graph;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// if not values found, set original
	
	graph = [[CPXYGraph alloc] initWithFrame: hostingView.bounds];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
    [graph applyTheme:theme];
	
	graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.cornerRadius = 0.0f;
	
	graph.paddingLeft = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 00.0f;
	
	graph.plotAreaFrame.paddingLeft = 50.0;
	graph.plotAreaFrame.paddingTop = 0.0;
	graph.plotAreaFrame.paddingRight = 0.0;
	graph.plotAreaFrame.paddingBottom = 40.0;
	
	hostingView.hostedGraph = graph;
	
	CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
	//plotSpace.allowsUserInteraction = YES;
	plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0)
												   length:CPDecimalFromFloat(5000)];
	plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.5)
												   length:CPDecimalFromFloat(1.0)];
	
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
	
	CPLineStyle *lineStyle = [CPLineStyle lineStyle];
	lineStyle.lineColor = [CPColor blackColor];
	lineStyle.lineWidth = 2.0f;
	
	//axisSet.xAxis.majorIntervalLength = [NSDecimalNumber decimalNumberWithString:@"5"];
	/*axisSet.xAxis.majorIntervalLength = CPDecimalFromString(@"28800.0");
	 axisSet.xAxis.minorTicksPerInterval = 5;
	 axisSet.xAxis.majorTickLineStyle = lineStyle;
	 axisSet.xAxis.minorTickLineStyle = lineStyle;
	 axisSet.xAxis.axisLineStyle = lineStyle;
	 axisSet.xAxis.minorTickLength = 5.0f;
	 axisSet.xAxis.majorTickLength = 7.0f;
	 axisSet.xAxis.title = @"Hours since now";
	 axisSet.xAxis.titleLocation = CPDecimalFromFloat(7.5f);
	 axisSet.xAxis.titleOffset = 55.0f;*/
	
	CPXYAxis *x = axisSet.xAxis;
    x.axisLineStyle = lineStyle;
    x.majorTickLineStyle = lineStyle;
    x.minorTickLineStyle = lineStyle;
    x.majorIntervalLength = CPDecimalFromString(@"1000");
    x.orthogonalCoordinateDecimal = CPDecimalFromString(@"0.5");
	x.title = @"Volume";
    x.titleLocation = CPDecimalFromFloat(2500);
	x.titleOffset = 20.0f;
	NSNumberFormatter *formatter2 = [[NSNumberFormatter alloc] init]; 
	[formatter2 setNumberStyle:NSNumberFormatterDecimalStyle];
	x.labelFormatter=formatter2;
	
	//x.isFloatingAxis=YES;
	//CPConstraints cp = { CPConstraintNone, CPConstraintFixed };
    //x.constraints = cp;
	x.labelingOrigin = CPDecimalFromString(@"0");
	
	//axisSet.xAxis.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
	//axisSet.xAxis.axisLabelOffset = 3.0f;
	
	//axisSet.yAxis.majorIntervalLength = [NSDecimalNumber decimalNumberWithString:@"5"];
	axisSet.yAxis.majorIntervalLength = CPDecimalFromString(@"0.1");
	axisSet.yAxis.minorTicksPerInterval = 4;
	axisSet.yAxis.majorTickLineStyle = lineStyle;
	axisSet.yAxis.minorTickLineStyle = lineStyle;
	axisSet.yAxis.axisLineStyle = lineStyle;
	axisSet.yAxis.minorTickLength = 5.0f;
	axisSet.yAxis.majorTickLength = 7.0f;
	axisSet.yAxis.title = @"";
	axisSet.yAxis.orthogonalCoordinateDecimal = CPDecimalFromString(@"0");
	axisSet.yAxis.titleOffset = 25.0f;
    axisSet.yAxis.titleLocation = CPDecimalFromFloat(150.0f);
	axisSet.yAxis.isFloatingAxis=YES;
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init]; 
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	axisSet.yAxis.labelFormatter=formatter;
	//axisSet.yAxis.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
	//axisSet.yAxis.axisLabelOffset = 3.0f;
	
	CPScatterPlot *askPlot = [[[CPScatterPlot alloc] 
									initWithFrame:graph.bounds] autorelease];
	askPlot.identifier = @"Ask";
	askPlot.dataLineStyle.lineWidth = 1.0f;
	askPlot.dataLineStyle.lineColor = [CPColor greenColor];
	askPlot.plotSymbol=[CPPlotSymbol ellipsePlotSymbol];
	askPlot.plotSymbol.lineStyle.lineColor=[CPColor greenColor];
	askPlot.dataSource = self;
	[graph addPlot:askPlot];
	
	CPScatterPlot *bidPlot = [[[CPScatterPlot alloc] 
									initWithFrame:graph.bounds] autorelease];
	bidPlot.identifier = @"Bid";
	bidPlot.dataLineStyle.lineWidth = 1.0f;
	bidPlot.dataLineStyle.lineColor = [CPColor redColor];
	bidPlot.plotSymbol=[CPPlotSymbol ellipsePlotSymbol];
	bidPlot.plotSymbol.lineStyle.lineColor=[CPColor redColor];
	bidPlot.dataSource = self;
	[graph addPlot:bidPlot];
	
	//graph.paddingLeft = 20.0;
	//graph.paddingTop = 20.0;
	//graph.paddingRight = 20.0;
	//graph.paddingBottom = 20.0;
	
	[self refreshChart2];
}

- (void)refreshChart2 {
	iPhoneBitcoinAppDelegate *appDelegate = (iPhoneBitcoinAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.marketDepth!=nil)
	{
		minX=2147483646;
		maxX=0;
		minY=999999.99;
		maxY=0.0;
		int i=0;
		for (i=0; i<[[appDelegate.marketDepth objectForKey:@"asks"] count]; i++) {
			int x=[[[[appDelegate.marketDepth objectForKey:@"asks"] objectAtIndex:i] objectAtIndex:1] intValue];
			//NSLog(@"blaa %d", x);
			if (x<minX)
			{
				minX=x;
				//NSLog(@"blaa3 %d", x);
			}
			if (x>maxX)
			{
				maxX=x;
				//NSLog(@"blaa4 %d", x);
			}
			float y=[[[[appDelegate.marketDepth objectForKey:@"asks"] objectAtIndex:i] objectAtIndex:0] floatValue];
			if (y<minY)
				minY=y;
			if (y>maxY)
				maxY=y;
		}
		for (i=0; i<[[appDelegate.marketDepth objectForKey:@"bids"] count]; i++) {
			int x=[[[[appDelegate.marketDepth objectForKey:@"bids"] objectAtIndex:i] objectAtIndex:1] intValue];
			//NSLog(@"blaa %d", x);
			if (x<minX)
			{
				minX=x;
				//NSLog(@"blaa3 %d", x);
			}
			if (x>maxX)
			{
				maxX=x;
				//NSLog(@"blaa4 %d", x);
			}
			float y=[[[[appDelegate.marketDepth objectForKey:@"bids"] objectAtIndex:i] objectAtIndex:0] floatValue];
			if (y<minY)
				minY=y;
			if (y>maxY)
				maxY=y;
		}
		NSLog(@"foo %d %d %f %f", minX, maxX, minY, maxY);
		//plotSpace.allowsUserInteraction = YES;
		CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
		plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0)
													   length:CPDecimalFromFloat((float)(maxX))];
		plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(minY-(maxY-minY)*0.05)
													   length:CPDecimalFromFloat((maxY-minY)*1.20)];
		
		CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
		axisSet.xAxis.orthogonalCoordinateDecimal=CPDecimalFromFloat(minY-(maxY-minY)*0.05);
		axisSet.xAxis.titleLocation = CPDecimalFromFloat((float)(maxX)*0.5);
		//axisSet.yAxis.titleLocation = CPDecimalFromFloat(minY+(maxY-minY)*0.5);
		
		[self.hostingView.hostedGraph reloadData];
		[self.graph reloadData];
		[self.graph setNeedsLayout];
		[self.graph setNeedsDisplay];
	}
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark data source

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot  {
	iPhoneBitcoinAppDelegate *appDelegate = (iPhoneBitcoinAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.marketDepth==nil)
		return 0;
	if ([(NSString *)plot.identifier isEqualToString:@"Ask"])
		return [[appDelegate.marketDepth objectForKey:@"asks"] count];
	return [[appDelegate.marketDepth objectForKey:@"bids"] count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot 
					 field:(NSUInteger)fieldEnum 
			   recordIndex:(NSUInteger)index 
{
	iPhoneBitcoinAppDelegate *appDelegate = (iPhoneBitcoinAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//return [NSNumber numberWithFloat:0.7];
	
	if ([(NSString *)plot.identifier isEqualToString:@"Ask"])
	{
		if ( fieldEnum == CPScatterPlotFieldX )
		{
			return [NSNumber numberWithFloat:(float)([[[[appDelegate.marketDepth objectForKey:@"asks"] objectAtIndex:index] objectAtIndex:1] intValue]) ];
		}
		
		return [NSNumber numberWithFloat:[[[[appDelegate.marketDepth objectForKey:@"asks"] objectAtIndex:index] objectAtIndex:0] floatValue]];
	}
	
	if ( fieldEnum == CPScatterPlotFieldX )
	{
		return [NSNumber numberWithFloat:(float)([[[[appDelegate.marketDepth objectForKey:@"bids"] objectAtIndex:index] objectAtIndex:1] intValue]) ];
	}
	
	return [NSNumber numberWithFloat:[[[[appDelegate.marketDepth objectForKey:@"bids"] objectAtIndex:index] objectAtIndex:0] floatValue]];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
