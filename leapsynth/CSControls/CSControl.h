//
//  CSControl.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CSControl : NSControl
{
    double value;    
    double minValue;
    double maxValue;
    
    id target;
    SEL action;
    
    NSString *parameter;
    
}
@property double minValue;
@property double maxValue;
@property NSString *parameter;

@property id target;
@property SEL action;

- (void)setDoubleValue:(double)value;
- (double)doubleValue;
- (double)normalizeValue;
- (void)performAction;
@end
