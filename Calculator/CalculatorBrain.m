//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Mike Goodspeed on 5/5/11.
//  Copyright 2011 Mike Goodspeed. All rights reserved.
//

#import "CalculatorBrain.h"


@implementation CalculatorBrain

- (void)setOperand:(double)aDouble
{
    operand = aDouble;
}

- (void)performWaitingOperation
{
    if ([@"+" isEqual:waitingOperation])
    {
        operand = waitingOperand + operand;
    }
    else if ([@"-" isEqual:waitingOperation])
    {
        operand = waitingOperand - operand;
    }
    else if ([@"*" isEqual:waitingOperation])
    {
        operand = waitingOperand * operand;
    }
    else if ([@"/" isEqual:waitingOperation])
    {
        if (operand)
        {
            operand = waitingOperand / operand;
        }
    }
}

- (double)performOperation:(NSString *)operation
{
    if ([operation isEqual:@"sqrt"])
    {
        operand = sqrt(operand);
    }
    else
    {
        [self performWaitingOperation];
        waitingOperation = operation;
        waitingOperand = operand;
    }
    return operand;
}
@end
