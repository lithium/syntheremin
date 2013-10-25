//
//  CSKnob.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSControl.h"

#define kCoarseModifier  20
#define kFineModifier    50


// we want knob to be: 7 oclock: 0, clockwise to 5 oclock: 1.0
#define kRadianHour    (2*M_PI/12) 
#define kRadianRange   kRadianHour*10
#define kKnobRangeMin  kRadianHour*5
#define kKnobRangeMax  kRadianHour*7

@interface CSKnob : CSControl
{
    NSImage *knobImage;
    NSImage *trackImage;
    NSImage *fillImage;

    NSSize knobSize, trackSize;
    
    NSPoint lastDragPoint;
    BOOL dragging;
    BOOL dragIsCoarse;
}

@end
