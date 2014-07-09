//
//  GraphViewController.h
//  Calclulator
//
//  Created by antonis ber on 4/26/12.
//  Copyright (c) 2012 adberkak@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"
#import "CalculatorViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter>


@property (nonatomic, strong) NSMutableArray *graphStack;
@property (nonatomic, strong) NSString *description;
@property (strong, nonatomic) IBOutlet UILabel *descrGraph;



- (void)setLabel:(NSString *)label;

@end
