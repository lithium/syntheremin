//
//  CSControl.m
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSControl.h"

@implementation CSControl
@synthesize minValue;
@synthesize maxValue;
@synthesize target;
@synthesize action;
@synthesize parameter;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        minValue = 0;
        maxValue = 1.0;
    }
    
    return self;
}

- (void)setDoubleValue:(double)newValue
{
    double oldValue = value;
    value = MIN(MAX(newValue, minValue), maxValue);
    if (value != oldValue) {
        [self performAction];
    }
    [self setNeedsDisplay:YES];
}
- (double)doubleValue
{
    return value;
}
- (double)normalizeValue
{
    return value / (maxValue - minValue);
}


- (void)performAction
{
    if ([target respondsToSelector:action]) {
        [target performSelector:action withObject:self];
    }
}
@end
