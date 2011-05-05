//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Mike Goodspeed on 5/5/11.
//  Copyright 2011 Mike Goodspeed. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalculatorBrain : NSObject {
    double operand;
    double waitingOperand;
    NSString *waitingOperation;
}

- (void)setOperand:(double)aDouble;
- (double)performOperation:(NSString *)operation;

@end
