//
//  CSControl.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kCoarseModifier  500
#define kFineModifier    1500

@interface CSSlider : NSControl
{
    double value;    
    double minValue;
    double maxValue;
    
    id target;
    SEL action;
    
}
@property double minValue;
@property double maxValue;

@property id target;
@property SEL action;

- (void)setDoubleValue:(double)value;
- (double)doubleValue;
- (double)normalizeValue;

@end
