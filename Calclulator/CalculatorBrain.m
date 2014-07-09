//
//  CalculatorBrain.m
//  Calclulator
//
//  Created by antonis ber on 3/7/12.
//  Copyright (c) 2012 adberkak@gmail.com. All rights reserved.
//

#import "CalculatorBrain.h"
#import "math.h"

@interface CalculatorBrain()
@property (nonatomic,strong) NSMutableArray  *programStack;
@property (nonatomic) BOOL twoOperand;
@property (nonatomic) BOOL oneOperand;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize VariableValues;
@synthesize twoOperand;
@synthesize oneOperand;

-(void)test
{
   // NSString *  aa=[VariableValues objectForKey:@"a"];
    //NSString *aa=a;
    //NSLog(@"to a einai %@",aa);
    
}
/*
+(NSString *) Dic:(NSString *) key
{
     NSString *  aa=[VariableValues objectForKey:key];
    return aa;
}
*/

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}



- (void) pushOperand:(double) operand
{
    NSNumber *operandObject=[NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}


- (double)performOperation:(NSString *)operation
{
    if([operation isEqualToString:@"runonly"]) 
        return [[self class] runProgram:self.program usingVariableValues: self.VariableValues];
    
    else if(!([operation isEqualToString:@""])) [self.programStack addObject:operation];
    else [self popOperand ];
    return [[self class] runProgram:self.program usingVariableValues: self.VariableValues];
}
- (void) popOperand
{
    id topOfStack = [self.programStack lastObject];
    if (topOfStack) [self.programStack removeLastObject];
    
}

//------these 4 boolean methods are used to check for operands



+(BOOL)isDoubleOperandOperation:(NSString *)oper{
    if ([oper isEqualToString:@"+"] || [oper isEqualToString:@"-"] || [oper isEqualToString:@"*"] || [oper isEqualToString:@"/"]  ) {
        return YES;
    }
    return NO;
}


+(BOOL)isSingleOperandOperation:(NSString *)oper{
    if ([oper isEqualToString:@"sqrt"] || [oper isEqualToString:@"sin"] || [oper isEqualToString:@"cos"] || [oper isEqualToString:@"log"]  ) {
        return YES;
    }
    return NO;
}

+(BOOL)isVariable:(NSString *)oper{
    if ([oper isEqualToString:@"x"] || [oper isEqualToString:@"a"] || [oper isEqualToString:@"b"]  ) {
        return YES;
    }
    return NO;
}

+(BOOL)isNoOperandOperation:(NSString *)oper{
    if ([oper isEqualToString:@"pi"] || [oper isEqualToString:@"e"] ) {
        return YES;
    }
    return NO;
}



+(NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    NSMutableString *programFragment = [NSMutableString stringWithString:@""];
    
    id topOfStack = [stack lastObject];
    if (topOfStack)   [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        [programFragment appendFormat:@"%g", [topOfStack doubleValue]];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([self isDoubleOperandOperation:operation]) {
            
            NSString *temp=[self descriptionOfTopOfStack:stack];
            [programFragment appendFormat:@"(%@ %@ %@)", [self descriptionOfTopOfStack:stack], operation, temp];
        } else if ([self isSingleOperandOperation:operation]) {
            
            /*if([programFragment hasPrefix:@"("]) 
                [programFragment appendFormat:@"%@ %@ ", operation, [self descriptionOfTopOfStack:stack]];
            else
              */  
            [programFragment appendFormat:@"%@( %@ )", operation, [self descriptionOfTopOfStack:stack]];
        } else if ([ self isNoOperandOperation:operation]) {
          // NSLog(@"mpike sto no operand");
            [programFragment appendFormat:@"%@", operation];
        } else if ([self isVariable:operation]) {
            [programFragment appendFormat:@"%@", operation];
        }
    }
    
    return programFragment;
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self descriptionOfTopOfStack:stack];
}





+ (double)popOperandOffProgramStack:(NSMutableArray *)stack usingVariableValues:(NSDictionary *)variableValues
{
    
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    // NSLog(@"to top of stack einai %@",topOfStack);
    
   
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        
        
        //------
        // the 3 conditions below is for the three variables----------
        if([topOfStack isEqualToString:@"x"])
        {
        //    NSLog(@"to to x meso tin operand stack %@",[variableValues objectForKey:@"x"]);
            return  result=[[variableValues objectForKey:@"x"] doubleValue];
        //    NSLog(@"to result pou tha gyrisei %f",result );
            
        }
        else if([topOfStack isEqualToString:@"a"])
        {
      //      NSLog(@"to to a meso tin operand stack %@",[variableValues objectForKey:@"a"]);
            return  result=[[variableValues objectForKey:@"a"] doubleValue];
        //    NSLog(@"to result pou tha gyrisei %f",result );
            
        }
        else if([topOfStack isEqualToString:@"b"])
        {
          //  NSLog(@"to to b meso tin operand stack %@",[variableValues objectForKey:@"b"]);
           return  result=[[variableValues objectForKey:@"b"] doubleValue];
      //      NSLog(@"to result pou tha gyrisei %f",result );
            
        }
        
        
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] +
            [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] *
           [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if (divisor) result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] / divisor;
        }
        else if ([operation isEqualToString:@"sqrt"]) {
            
            result=sqrt([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        }
        else if ([operation isEqualToString:@"sin"]) {
            
            result=sin((2*[self popOperandOffProgramStack:stack usingVariableValues:variableValues]*M_PI)/360);
        }
        else if ([operation isEqualToString:@"cos"]) {
            
            result=cos((2*[self popOperandOffProgramStack:stack usingVariableValues:variableValues]*M_PI)/360);
            
            
        }
        else if ([operation isEqualToString:@"log"]) {
            
            result=log10([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        }
        else if ([operation isEqualToString:@"pi"]) {
            
            //result=  M_PI*([self popOperand]);
            result= M_PI;
            
        }
        else if ([operation isEqualToString:@"e"]) {
            
            //result=  M_E*([self popOperand]);
            result =M_E;
            
            
        }
        
    }
    
    return result;
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
}


@end
