//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Mike Goodspeed on 5/5/11.
//  Copyright 2011 Mike Goodspeed. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
+ (BOOL)isVariable:(NSString *)aString;
@end

@implementation CalculatorBrain

#pragma Class Methods

+ (BOOL)isVariable:(NSString *)aString
{
    return [aString hasPrefix:@"%"] && [aString length] > 1;
}

+ (NSString *)descriptionOfExpression:(id)anExpression
{
    NSMutableString *output = [NSMutableString string];
    for (id item in anExpression)
    {
        if ([item isKindOfClass:[NSString class]])
        {
            if ([CalculatorBrain isVariable:item])
            {
                NSLog(@"variable: %@", [item substringFromIndex:1]);
                [output appendString:[item substringFromIndex:1]];
            }
            else
            {
                [output appendString:item];
            }
        }
        else if ([item isKindOfClass:[NSNumber class]])
        {
            [output appendString:[item stringValue]];
        }
        [output appendString:@" "];
    }
    return output;
}

+ (NSSet *)variablesInExpression:(id)anExpression
{
    NSMutableSet *output = [NSMutableSet set];
    for (id item in anExpression)
    {
        if ([CalculatorBrain isVariable:item])
        {
            [output addObject:[item substringFromIndex:1]];
        }
    }
    return output;
}

+ (id)propertyListForExpression:(id)anExpression
{
    return [[anExpression copy] autorelease];
}

+ (id)expressionForPropertyList:(id)propertyList;
{
    return [[propertyList copy] autorelease];   
}


+ (double)evaluateExpression:(id)anExpression
              usingVariables:(NSDictionary *)variables
{
    CalculatorBrain *brain = [[CalculatorBrain alloc] init];
    double output = 0;
    for (id item in anExpression)
    {
        if ([item isKindOfClass:[NSString class]])
        {
            if ([CalculatorBrain isVariable:item])
            {
                [brain setVariableAsOperand:[item substringFromIndex:1]];
            }
            else
            {
                output = [brain performOperation:item];
            }
        }
        else if ([item isKindOfClass:[NSNumber class]])
        {
            [brain setOperand:[item doubleValue]];
        }

    }
    [brain release];
    return output;
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

@synthesize containsVariable = containsVariable_;

- (id)expression
{
    return [NSArray arrayWithArray:internalExpression];
}

#pragma Memory

- (void) dealloc
{
    [waitingOperation release];
    [internalExpression release];
    [variable release];
    [super dealloc];
}

#pragma - Brain

- (void)setVariableAsOperand:(NSString *)variableName
{
    containsVariable_ = YES;
    variable = [variableName retain];
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
        [variable release];
        containsVariable_ = NO;
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
