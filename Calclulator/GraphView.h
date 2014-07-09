//
//  GraphView.h
//  Calclulator
//
//  Created by antonis ber on 4/26/12.
//  Copyright (c) 2012 adberkak@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"
#import "CalculatorBrain.h"

@class GraphView;

@protocol GraphViewDataSource
- (float)deltaY:(GraphView *)sender;
@end

@interface GraphView : UIView


@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGFloat xValue;
@property (nonatomic) CGPoint originOffset;


// the gestures that are recognized!
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)TripleTap:(UITapGestureRecognizer *)recognizer;

@end
