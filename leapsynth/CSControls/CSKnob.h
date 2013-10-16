//
//  CSKnob.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSSlider.h"

// we want knob to be: 7 oclock: 0, clockwise to 5 oclock: 1.0
#define kRadianHour    (2*M_PI/12) 
#define kRadianRange   kRadianHour*10
#define kKnobRangeMin  kRadianHour*5
#define kKnobRangeMax  kRadianHour*7

#define kLabelHeight   20

@interface CSKnob : CSSlider
{
    NSImage *image;
    
    NSString *label;
    NSDictionary *labelAttributes;
    NSRect labelRect;
}

@end
