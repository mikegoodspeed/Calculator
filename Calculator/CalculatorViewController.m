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

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Controller Code

- (CalculatorBrain *)brain
{
    if (!brain) {
        brain = [[CalculatorBrain alloc] init];
    }
    return brain;
}

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
    display.text = [NSString stringWithFormat:@"%g", result];
}

# pragma mark - Memory allocation

- (void)dealloc
{
    [brain release];
    [super dealloc];
}

@end
