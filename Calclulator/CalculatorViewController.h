//
//  CalculatorViewController.h
//  Calclulator
//
//  Created by antonis ber on 3/7/12.
//  Copyright (c) 2012 aberkakis@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *display2;
@property (weak, nonatomic) IBOutlet UILabel *displayVar;
@property (weak, nonatomic) IBOutlet UILabel *display3;
@property (nonatomic,strong) CalculatorBrain *brain;

@end
