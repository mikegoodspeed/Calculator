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
    double memory;
    id internalExpression;
}

- (void)setOperand:(double)aDouble;
- (void)setVariableAsOperand:(NSString *)variableName;
- (double)performOperation:(NSString *)operation;

@property (readonly, nonatomic) id expression;

+ (double)evaluateExpression:(id)anExpression
              usingVariables:(NSDictionary *)variables;

+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;

+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
