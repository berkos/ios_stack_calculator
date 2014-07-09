//
//  CalculatorBrain.h
//  Calclulator
//
//  Created by antonis ber on 3/7/12.
//  Copyright (c) 2012 adberkak@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double) operand;
- (double) performOperation:(NSString *) operation;

- (void) popOperand;

- (void) test;

@property NSMutableDictionary *VariableValues;
@property (readonly) id program;


+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;


@end
