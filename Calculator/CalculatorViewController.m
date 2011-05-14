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
    
    if ([CalculatorBrain variablesInExpression:brain.expression])
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
    userIsInTheMiddleOfTypingANumber = NO;
    NSDictionary *vars = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"x", [NSNumber numberWithInt:2], 
                          @"a", [NSNumber numberWithInt:4],
                          @"b", [NSNumber numberWithInt:6], nil];
    double result = [CalculatorBrain evaluateExpression:self.brain.expression
                                         usingVariables:vars];
    display.text = [NSString stringWithFormat:@"%g", result];
}

@end
