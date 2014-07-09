//
//  CalculatorViewController.m
//  Calclulator
//
//  Created by antonis ber on 3/7/12.
//  Copyright (c) 2012 aberkakis@gmail.com. All rights reserved.
//

#import "CalculatorViewController.h"

#import "GraphView.h"
#import "GraphViewController.h"
#import "SplitViewBarButtonItemPresenter.h"


@interface CalculatorViewController ()
@property (nonatomic) BOOL userIdInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL plin;
@property (nonatomic) BOOL pe; // a bool that is used to avoid printing of number pi.




@end

@implementation CalculatorViewController

@synthesize display;
@synthesize display2;
@synthesize displayVar;
@synthesize display3;

@synthesize userIdInTheMiddleOfEnteringANumber;
@synthesize plin;
@synthesize pe;
@synthesize brain=_brain;

//---------------------------------------------------------this is a try for the ipad orientetion and toolbar--------------------------------------
- (void)awakeFromNib  // always try to be the split view's delegate
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{ 
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{ 
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Antonis' Calculator";
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}




// Does the bar button item transfer from existing detail view controller to destination

- (void)transferSplitViewBarButtonItemToViewController:(id)destinationViewController
{
    UIBarButtonItem *splitViewBarButtonItem = [[self splitViewBarButtonItemPresenter] splitViewBarButtonItem];
    [[self splitViewBarButtonItemPresenter] setSplitViewBarButtonItem:nil];
    if (splitViewBarButtonItem) {
        [destinationViewController setSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}


//----------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)Graph_action {
    
    if ([self splitViewGraphViewController]) {          
        // if in split view
       // NSLog(@"einai split view!!");
        [[self splitViewGraphViewController] setGraphStack:[self.brain program]];
        [[self splitViewGraphViewController] setLabel:[CalculatorBrain descriptionOfProgram:[self.brain program]]];
        

    } else {
       // NSLog(@"DEN EINAI  split view!!");
      // // [self performSegueWithIdentifier:@"Graph" sender:self]; // else segue using ShowDiagnosis
    }
    
}



- (GraphViewController *)splitViewGraphViewController
{
    id hvc = [self.splitViewController.viewControllers lastObject];
    if (![hvc isKindOfClass:[GraphViewController class]]) {
        hvc = nil;
    }
    return hvc;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Graph"]) {
        
        [segue.destinationViewController setGraphStack:[self.brain program]];
        //Fix next line.
        [segue.destinationViewController setLabel:[CalculatorBrain descriptionOfProgram:[self.brain program]]];
      
    }
}

-(CalculatorBrain *)brain
{
    if(!_brain) _brain=[[CalculatorBrain alloc]init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit= [ sender currentTitle];
    if(self.userIdInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        self.display.text=digit;

        self.userIdInTheMiddleOfEnteringANumber=YES;
    }
    
}
- (IBAction)enterPressed 
{
    NSString * temp=@"=";
    
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    if(!self.pe){
    self.display2.text=[self.display2.text substringToIndex:[self.display2.text length]-1 ]; // edo afairoume to =.
     self.display2.text=[self.display2.text stringByAppendingString:self.display.text];
    self.display2.text=[self.display2.text stringByAppendingString:@" "];
    
    self.display2.text = [self.display2.text stringByAppendingString:temp ]; // edo to ksanaprosthetoume to =.
    }
    
    self.pe=NO;
    self.userIdInTheMiddleOfEnteringANumber=NO;
    plin=NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    
    NSString *operation=sender.currentTitle;
    
    if([operation isEqual:@"pi"] || [operation isEqual:@"e"] || [operation isEqual:@"x"] || [operation isEqual:@"a"] || [operation isEqual:@"b"] ) {self.pe=YES; // NSLog(@"mpike sto yes");
    }
    
    if (self.userIdInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    
    
     NSString * temp=@"=";
    self.display2.text=[self.display2.text substringToIndex:[self.display2.text length]-1 ]; // edo afairoume to =.
    self.display2.text=[self.display2.text stringByAppendingString:sender.currentTitle];
    self.display2.text=[self.display2.text stringByAppendingString:@" "];
    self.display2.text = [self.display2.text stringByAppendingString:temp ]; // edo to ksanaprosthetoume to =.

   // self.display3.text=[[self.brain class] descriptionOfProgram:self.brain.program];
    double result = [self.brain performOperation:operation]; // edo kalei tin synartisi tou brain.
    self.display.text=[NSString stringWithFormat:@"%g",result];
    
    
    self.display3.text=[[self.brain class] descriptionOfProgram:self.brain.program];
    
}
- (IBAction)clear 
{
    self.display2.text=@"=";
    self.display.text=@"0";
    self.display3.text=@"";
    self.userIdInTheMiddleOfEnteringANumber=NO;
    plin=NO;
    //_brain=[[CalculatorBrain alloc]init];
    _brain=nil;
    [self.brain.VariableValues removeAllObjects];
    self.displayVar.text=@"set Variables";
    
    
}


- (IBAction)Undo {
    if(self.userIdInTheMiddleOfEnteringANumber){
        
        if(self.display.text.length>1){ // check if there is something for delete
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        }
        else {
            self.userIdInTheMiddleOfEnteringANumber=NO;
            // we want just a simple run of the programm.
            double result = [self.brain performOperation:@"runonly"];
            self.display.text=[NSString stringWithFormat:@"%g",result];
            // [self.brain popOperand];
            self.display3.text=[[self.brain class] descriptionOfProgram:self.brain.program];
        }
    }
    else
    {
        // we want to pop the first object from the stack and then 
        // run the programm.
        double result = [self.brain performOperation:@""];
        self.display.text=[NSString stringWithFormat:@"%g",result];
        self.display3.text=[[self.brain class] descriptionOfProgram:self.brain.program];
        
    }
    
}


- (IBAction)sin_plin 
{
    NSString *temp;
    if(!plin){
        temp=@"-";
        self.display.text = [temp stringByAppendingString:self.display.text ]; 
        plin=YES;
    }
    else{// case for positive, it just removes ( - ) from the beginnig.

        self.display.text = [self.display.text substringFromIndex:1]; 
        plin=NO;
    }
}

- (IBAction)test1:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:@"setX"])
    {
        self.brain.VariableValues=[NSDictionary dictionaryWithObjectsAndKeys:
                               //[NSNumber numberWithDouble:2.0], @"x",
                               [NSNumber numberWithDouble:[self.display.text doubleValue]], @"x",
                               [NSNumber numberWithDouble:4.0], @"b", nil];
      //  self.displayVar.text= @"x= %@ ",self.display.text;
        
        NSMutableString *tt2=[NSMutableString stringWithString:@""];
        [tt2  appendFormat:@"x--> %@ ", self.display.text];
        self.displayVar.text =tt2;
        self.display.text=@"";
    }
    else if([sender.currentTitle isEqualToString:@"test3"])
    {
        self.brain.VariableValues=[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:552.0], @"x",
                                   [NSNumber numberWithDouble:364.0], @"a",
                                   [NSNumber numberWithDouble:-7654.0], @"b", nil];
        self.displayVar.text=@"b=552.0  a=364.0  b=-7654.0 ";
    }
    else if([sender.currentTitle isEqualToString:@"test2"])
    {
        self.brain.VariableValues=[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble: -4.0], @"x",
                                   [NSNumber numberWithDouble:3.0], @"a",
                                   //[NSNumber numberWithDouble:4.0], @"b",
                                   nil];
        self.displayVar.text=@"x=-4.0  a=3.0 ";
    }
        
        
        
        [self.brain test];
    
}





/*
- (void)viewDidUnload {
    [self setDisplay2:nil];
    [super viewDidUnload];
}*/
- (void)viewDidUnload {
    [self setDisplayVar:nil];
    [self setDisplay3:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return  YES;
}


@end



