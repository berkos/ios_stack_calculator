//
//  GraphView.m
//  Calclulator
//
//  Created by antonis ber on 4/26/12.
//  Copyright (c) 2012 adberkak@gmail.com. All rights reserved.
//

#import "GraphView.h"
#import <Foundation/NSUserDefaults.h>
//#import  "NSUserDefaults.h"
@implementation GraphView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;
@synthesize xValue;
@synthesize originOffset;



#define DEFAULT_SCALE 0.80

- (CGFloat)scale
{
    if (!_scale) {
       // self.originOffset = CGPointMake(0, 0);
        return DEFAULT_SCALE; // if the user has not define his own scale it will redefined.
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // we need to redisplay because the scale changed
    }
}


- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; //adjust scale
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
		CGPoint translation = [gesture translationInView:self];
		CGPoint newOffset = CGPointMake(self.originOffset.x + translation.x,
										self.originOffset.y + translation.y);
		self.originOffset = newOffset;
		[gesture setTranslation:CGPointZero inView:self];
	}
}

- (void)TripleTap:(UITapGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateRecognized ) {
        
        //CGPoint location = [recognizer locationInView:recognizer.view];
      //  location.x-=self.bounds.origin.x ;
      //  location.y -=self.bounds.origin.y;
        // with the above we take the location of gesture.
        
        // i could not do the requested as i could not find the right offset,
        // so the other one i did was to make a reset for the position of axes!
		self.originOffset = CGPointMake(0, 0);
  
	}
}


- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}


- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us// Initialization code
    }
    return self;
}


- (void)setOriginOffset:(CGPoint)newOffset {
	//bounds checking goes here
	originOffset = newOffset;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint; //center in coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2 + originOffset.x; // with these two we define that
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2 + originOffset.y;// the center of x-y will be at the center 
    
    //Draw Axes
   // self.scale=0.98; // just a random number for the beggining
    CGRect rect1 = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [AxesDrawer drawAxesInRect:rect1 originAtPoint:midPoint scale:[self scale ]];
  //  [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:self.scale*self.contentScaleFactor];

    
	UIGraphicsPushContext(context);
    
    // we define the color of the grapic equation
    CGContextSetLineWidth(context, 2);
    [[UIColor redColor] setStroke];
    
    // Now we start to draw some lines..

    for (CGFloat pixel = 0; pixel <= self.bounds.size.width; pixel++) {
		CGPoint nextPointInViewCoordinates;
		nextPointInViewCoordinates.x = pixel;
		
		CGPoint nextPointInGraphCoordinates;
		nextPointInGraphCoordinates.x = (nextPointInViewCoordinates.x - midPoint.x)/(self.scale * self.contentScaleFactor);
        xValue=nextPointInGraphCoordinates.x; // we vhange the x-value so we can call the graphBrain!
		nextPointInGraphCoordinates.y =  [self.dataSource deltaY:self];
		nextPointInViewCoordinates.y = midPoint.y - (nextPointInGraphCoordinates.y * self.scale * self.contentScaleFactor);
		
		if (pixel == 0) {
            // firt time we move to point so we can add the first point and then draw some lines.
			CGContextMoveToPoint(context, nextPointInViewCoordinates.x, nextPointInViewCoordinates.y);
		} else {
			CGContextAddLineToPoint(context, nextPointInViewCoordinates.x, nextPointInViewCoordinates.y);
		}
    }
    
    CGContextStrokePath(context);
	UIGraphicsPopContext();
    
    
}


@end
