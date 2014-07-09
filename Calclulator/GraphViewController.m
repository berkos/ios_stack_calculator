//
//  GraphViewController.m
//  Calclulator
//
//  Created by antonis ber on 4/26/12.
//  Copyright (c) 2012 adberkak@gmail.com. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController() <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
// the above is the connection that we made for graphView with it's controller.
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar; 
@end



@implementation GraphViewController

NSString * labelS;
@synthesize graphStack = _graphStack;
@synthesize description = _description;
@synthesize descrGraph = _descrGraph;

@synthesize graphView= _graphView;

@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;   // implementation of SplitViewBarButtonItemPresenter protocol
@synthesize toolbar = _toolbar;                                 // to put splitViewBarButtonItem in

//-------------this is for the ipad implementation too

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

//--------------------------------






- (NSMutableArray *)graphStack
{
    if (_graphStack == nil) _graphStack = [[NSMutableArray alloc] init];
    return _graphStack;
}

- (GraphViewController *)init
{
    return [super init];
}



- (void)setGraphStack:(NSMutableArray *)graphStack
{
  //  NSLog(@"Setting the Graph Stack");
    _graphStack = graphStack;
    [self.graphView setNeedsDisplay]; // this works for the ipad split controller, we need to refresh the graph immediately after we set the Graph.

    
}

- (void)setLabel:(NSString *)label {
    if (_descrGraph == nil) _descrGraph = [[UILabel alloc] init];
       
       labelS=label; // we set the label with a string that calculatorView controller sent us.
       self.descrGraph.text=labelS;
}

- (void)setDescription:(NSString *)description
{
    _description = description;
    //[self.graphView setNeedsDisplay];
}

- (NSString *)description
{
    if (_description == nil) _description = [[NSString alloc] init];
   // [self.graphView setNeedsDisplay];
    return _description;
}




-(void) setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    
    
    //we just add the pinch and pan gestyres.
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector (pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector (pan:)]];
   // [self.graphView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(doubleTap:)]];
    
    // i write this down with a different way so i can put the numbers of tabs required.
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(TripleTap:)];
	tap.numberOfTapsRequired = 3;
	[graphView addGestureRecognizer:tap];
	/*[tapGR release];*/
    
    self.graphView.dataSource = self;  
}


// that's the function that we ask from the calculator brain to return the y-value.
- (float)deltaY:(GraphView *)sender
{
    float xVar = sender.xValue;
    
    id xVar2 = [NSNumber numberWithFloat:xVar];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:xVar2 forKey: @"x"];
    
    // graph stack is the function that is stored on the graph side.
    
    float result = [CalculatorBrain runProgram:self.graphStack usingVariableValues:dict];
    
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *frontName = [defaults objectForKey:@"firstname"];
    NSString *lastName = [defaults objectForKey:@"lastname"];
    
    int age = [defaults integerForKey:@"age"];
    NSString *ageString = [NSString stringWithFormat:@"%i",age];
    
    NSData *imageData = [defaults dataForKey:@"image"];
	UIImage *contactImage = [UIImage imageWithData:imageData];

    */
    
    self.descrGraph.text=labelS;
  //  [self.graphView setNeedsDisplay];
   // [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];// we set the label just before the view starts.
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
     return  YES;
}

@end
