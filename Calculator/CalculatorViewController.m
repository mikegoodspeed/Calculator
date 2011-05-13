//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Mike Goodspeed on 5/5/11.
//  Copyright 2011 Mike Goodspeed. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController()
@property (readonly) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

# pragma mark - Properties

- (CalculatorBrain *)brain
{
    if (!brain) {
        brain = [[CalculatorBrain alloc] init];
    }
    return brain;
}

# pragma mark - Memory

- (void)dealloc
{
    [brain release];
    [super dealloc];
}

#pragma mark - Controler Code

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    if (userIsInTheMiddleOfTypingANumber)
    {
        if ([digit isEqual:@"."])
        {
            NSRange range = [display.text rangeOfString:@"."];
            if (range.location == NSNotFound)
            {
                display.text = [display.text stringByAppendingString:digit];
            }
        }
        else
        {
            display.text = [display.text stringByAppendingString:digit];
        }
    }
    else
    {
        display.text = [digit isEqual:@"."] ? @"0." : digit;
        userIsInTheMiddleOfTypingANumber = YES;
    }    
}

- (IBAction)operandPressed:(UIButton *)sender
{
    if (userIsInTheMiddleOfTypingANumber)
    {
        [self.brain setOperand:[display.text doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    NSString *operation = sender.titleLabel.text;
    double result = [self.brain performOperation:operation];
    
    if (brain.containsVariable)
    {
        display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
    }
    else
    {
        display.text = [NSString stringWithFormat:@"%g", result];
    }
}

- (IBAction)setVariableAsOperand:(UIButton *)sender
{
    [brain setVariableAsOperand:sender.titleLabel.text];
    display.text = sender.titleLabel.text;
}

- (void)solve
{
    NSDictionary *vars = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"x", 2, @"a", 4, @"b", 6, nil];
    [CalculatorBrain evaluateExpression:self.brain.expression
                         usingVariables:vars];
}

@end
