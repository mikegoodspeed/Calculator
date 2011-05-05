//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Mike Goodspeed on 5/5/11.
//  Copyright 2011 Mike Goodspeed. All rights reserved.
//

#import "CalculatorViewController.h"

@implementation CalculatorViewController

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Controller Code

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [[sender titleLabel] text];
    if (userIsInTheMiddleOfTypingANumber)
    {
        if ([digit isEqual:@"."])
        {
            NSRange range = [[display text] rangeOfString:@"."];
            if (range.location == NSNotFound)
            {
                [display setText:[[display text] stringByAppendingString:digit]];
            }
        }
        else
        {
            [display setText:[[display text] stringByAppendingString:digit]];
        }
    }
    else
    {
        if ([digit isEqual:@"."])
        {
            [display setText:@"0."];
        }
        else
        {
            [display setText:digit];
        }
        userIsInTheMiddleOfTypingANumber = YES;
    }    
}

- (CalculatorBrain *)brain
{
    if (!brain) {
        brain = [[CalculatorBrain alloc] init];
    }
    return brain;
}

- (IBAction)operandPressed:(UIButton *)sender
{
    if (userIsInTheMiddleOfTypingANumber)
    {
        [[self brain] setOperand:[[display text] doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    NSString *operation = [[sender titleLabel] text];
    double result = [[self brain] performOperation:operation];
    [display setText:[NSString stringWithFormat:@"%g", result]];
}

# pragma mark - Memory allocation

- (void)dealloc
{
    [brain release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
