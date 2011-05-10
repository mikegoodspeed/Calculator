//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Mike Goodspeed on 5/5/11.
//  Copyright 2011 Mike Goodspeed. All rights reserved.
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain

#pragma Class Methods

+ (NSString *)descriptionOfExpression:(id)anExpression
{
    NSMutableString *output = [NSMutableString new];
    for (id item in anExpression)
    {
        if ([item isKindOfClass:[NSString class]])
        {
            [output appendString:item];
        }
        else if ([item isKindOfClass:[NSNumber class]])
        {
            [output appendString:[item stringValue]];
        }
        [output appendString:@" "];
    }
    return [output autorelease];
}

- (id)init
{
    if ((self = [super init]))
    {
        internalExpression = [NSMutableArray new];
    }
    return self;
}

#pragma Properties

- (id)expression
{
    return [NSArray arrayWithArray:internalExpression];
}

#pragma Memory

- (void) dealloc
{
    [waitingOperation release];
    [internalExpression release];
    [super dealloc];
}

- (void)setOperand:(double)aDouble
{
    [internalExpression addObject:[NSNumber numberWithDouble:aDouble]];
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
    if ([operation isEqual:@"x"] ||
        [operation isEqual:@"a"] ||
        [operation isEqual:@"b"])
    {
        NSString *vp = @"%";
        [internalExpression addObject:[vp stringByAppendingString:operation]];
    }
    else
    {
        [internalExpression addObject:operation];
    }
    if ([operation isEqual:@"sqrt"])
    {
        operand = sqrt(operand);
    }
    else if ([operation isEqual:@"1/x"])
    {
        operand = 1 / operand;
    }
    else if ([operation isEqual:@"+/-"])
    {
        operand *= -1;
    }
    else if ([operation isEqual:@"sin"])
    {
        operand = sin(operand);
    }
    else if ([operation isEqual:@"cos"])
    {
        operand = cos(operand);
    }
    else if ([operation isEqual:@"Store"])
    {
        memory = operand;
    }
    else if ([operation isEqual:@"Recall"])
    {
        operand = memory;
    }
    else if ([operation isEqual:@"Mem+"])
    {
        memory += operand;
    }
    else if ([operation isEqual:@"C"])
    {
        [waitingOperation release];
        waitingOperand = 0;
        waitingOperation = nil;
        memory = 0;
        operand = 0;
    }
    else
    {
        [self performWaitingOperation];
        waitingOperation = operation;
        [waitingOperation retain];
        waitingOperand = operand;
    }
    return operand;
}

@end
