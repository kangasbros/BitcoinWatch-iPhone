//
//  FirstViewController.m
//  iPhoneBitcoin
//
//  Created by Jeremias Kangas on 2/18/11.
//  Copyright 2011 Kangas Bros. Innovations. All rights reserved.
//

#import "FirstViewController.h"
#import "iPhoneBitcoinAppDelegate.h"


@implementation FirstViewController

@synthesize hostingView, labelLast, labelHigh;

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
	numValues=0;
	values=NULL;
	
	graph = [[CPXYGraph alloc] initWithFrame: hostingView.bounds];
	
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
												   length:CPDecimalFromFloat(3600*48)];
	plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.7)
												   length:CPDecimalFromFloat(0.1)];
	
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
    x.majorIntervalLength = CPDecimalFromString(@"28800");
    x.orthogonalCoordinateDecimal = CPDecimalFromString(@"0.7");
	x.title = @"Hours since now";
    x.titleLocation = CPDecimalFromFloat(28800.0*3);
	x.titleOffset = 20.0f;
	//x.isFloatingAxis=YES;
	//CPConstraints cp = { CPConstraintNone, CPConstraintFixed };
    //x.constraints = cp;
	
	// Define some custom labels for the data elements
	x.labelRotation = 0;
	x.labelingPolicy = CPAxisLabelingPolicyNone;
	NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:0], 
									[NSDecimalNumber numberWithInt:1*28800], 
									[NSDecimalNumber numberWithInt:2*28800], 
									[NSDecimalNumber numberWithInt:3*28800], 
									[NSDecimalNumber numberWithInt:4*28800], 
									[NSDecimalNumber numberWithInt:5*28800], 
									[NSDecimalNumber numberWithInt:6*28800], 
									nil];
	NSArray *xAxisLabels = [NSArray arrayWithObjects:@"48", @"40", @"32", @"24", @"16", @"8", @"0", nil];
	NSUInteger labelLocation = 0;
	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
	for (NSNumber *tickLocation in customTickLocations) {
		CPAxisLabel *newLabel = [[CPAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
		newLabel.tickLocation = [tickLocation decimalValue];
		newLabel.offset = x.labelOffset + x.majorTickLength;
		newLabel.rotation = 0;
		[customLabels addObject:newLabel];
		[newLabel release];
	}
	
	x.axisLabels =  [NSSet setWithArray:customLabels];
	x.labelingOrigin = CPDecimalFromString(@"0.5");
	
	//axisSet.xAxis.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
	//axisSet.xAxis.axisLabelOffset = 3.0f;
	
	//axisSet.yAxis.majorIntervalLength = [NSDecimalNumber decimalNumberWithString:@"5"];
	axisSet.yAxis.majorIntervalLength = CPDecimalFromString(@"0.05");
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
	
	CPScatterPlot *xSquaredPlot = [[[CPScatterPlot alloc] 
									initWithFrame:graph.bounds] autorelease];
	xSquaredPlot.identifier = @"X Squared Plot";
	xSquaredPlot.dataLineStyle.lineWidth = 1.0f;
	xSquaredPlot.dataLineStyle.lineColor = [CPColor redColor];
	xSquaredPlot.plotSymbol=[CPPlotSymbol ellipsePlotSymbol];
	xSquaredPlot.plotSymbol.lineStyle.lineColor=[CPColor redColor];
	xSquaredPlot.dataSource = self;
	[graph addPlot:xSquaredPlot];
	 
	CPPlotSymbol *greenCirclePlotSymbol = [CPPlotSymbol ellipsePlotSymbol];
	greenCirclePlotSymbol.fill = [CPFill fillWithColor:[CPColor greenColor]];
	greenCirclePlotSymbol.size = CGSizeMake(2.0, 2.0);
	
	//graph.paddingLeft = 20.0;
	//graph.paddingTop = 20.0;
	//graph.paddingRight = 20.0;
	//graph.paddingBottom = 20.0;
}

- (void)refreshChart {
	iPhoneBitcoinAppDelegate *appDelegate = (iPhoneBitcoinAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.lastTicker!=nil)
	{
		NSError *error = nil;
		//NSLog(@"JSON Object: %@ %p (Error: %@)", [[[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"last"] class], 
		//	  [[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"last"], error);
		//NSLog(NSDecimalString([[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"last"], nil));
		labelLast.text=[NSString stringWithFormat:@"%f", 
						[[[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"last"] floatValue]];
		labelVolume.text=[NSString stringWithFormat:@"%d", 
						[[[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"vol"] intValue]];
		labelHigh.text=[NSString stringWithFormat:@"%f", 
						[[[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"high"] floatValue]];
		labelLow.text=[NSString stringWithFormat:@"%f", 
						[[[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"low"] floatValue]];
		labelSell.text=[NSString stringWithFormat:@"%f", 
						[[[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"sell"] floatValue]];
		labelBuy.text=[NSString stringWithFormat:@"%f", 
						[[[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"buy"] floatValue]];
		labelLastRefresh.text=[NSString stringWithFormat:@"Last Refresh at %@", 
					   [appDelegate.lastFetch description]];
		
		//NSDecimalString([[appDelegate.lastTicker objectForKey:@"ticker"] objectForKey:@"last"], nil);
	}
	if (appDelegate.recentTrades!=nil)
	{
		minX=2147483646;
		maxX=0;
		minY=999999.99;
		maxY=0.0;
		CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
		for (int i=0; i<[appDelegate.recentTrades count]; i++) {
			int x=[[[appDelegate.recentTrades objectAtIndex:i] objectForKey:@"date"] intValue];
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
			float y=[[[appDelegate.recentTrades objectAtIndex:i] objectForKey:@"price"] floatValue];
			if (y<minY)
				minY=y;
			if (y>maxY)
				maxY=y;
		}
		NSLog(@"blaa2 %d %d %f %f", minX, maxX, minY, maxY);
		//plotSpace.allowsUserInteraction = YES;
		plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat((float)0.0-(float)(maxX-minX)*0.05)
													   length:CPDecimalFromFloat((float)(maxX-minX)*1.10)];
		plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(minY-(maxY-minY)*0.05)
													   length:CPDecimalFromFloat((maxY-minY)*1.10)];
		
		CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
		axisSet.xAxis.orthogonalCoordinateDecimal=CPDecimalFromFloat(minY-(maxY-minY)*0.05);
		axisSet.yAxis.titleLocation = CPDecimalFromFloat(minY+(maxY-minY)*0.5);
		
		[hostingView.hostedGraph reloadData];
		
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
	if (appDelegate.recentTrades==nil)
		return 0;
	return [appDelegate.recentTrades count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot 
					 field:(NSUInteger)fieldEnum 
			   recordIndex:(NSUInteger)index 
{
	iPhoneBitcoinAppDelegate *appDelegate = (iPhoneBitcoinAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//return [NSNumber numberWithFloat:0.7];
	
	if ( fieldEnum == CPScatterPlotFieldX )
	{
		return [NSNumber numberWithFloat:(float)([[[appDelegate.recentTrades objectAtIndex:index] objectForKey:@"date"] intValue]-minX) ];
	}
										  
	return [NSNumber numberWithFloat:[[[appDelegate.recentTrades objectAtIndex:index] objectForKey:@"price"] floatValue]];
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
