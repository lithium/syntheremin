//
//  CSControl.m
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSSlider.h"

@implementation CSSlider
@synthesize minValue;
@synthesize maxValue;
@synthesize target;
@synthesize action;


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
    value = MIN(MAX(newValue, minValue), maxValue);
    [self setNeedsDisplay:YES];
    if ([target respondsToSelector:action]) {
        [target performSelector:action withObject:self];
    }
}
- (double)doubleValue
{
    return value;
}
- (double)normalizeValue
{
    return value / (maxValue - minValue);
}


- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    lastDragPoint = [NSEvent mouseLocation];
    dragIsCoarse = YES;
    dragging = YES;
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    lastDragPoint = [NSEvent mouseLocation];
    dragIsCoarse = NO;
    dragging = YES;
    
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint pos = [NSEvent mouseLocation];
    double dragModifier = (dragIsCoarse ? kCoarseModifier : kFineModifier);
    double distance = (pos.y - lastDragPoint.y) / dragModifier;
    
    [self setDoubleValue:(value + distance)];
    [self setNeedsDisplay:YES];
    
    lastDragPoint = pos;
}

- (void)rightMouseDragged:(NSEvent *)theEvent
{
    [self mouseDragged:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    dragging = NO;
}
- (void)rightMouseUp:(NSEvent *)theEvent
{
    dragging = NO;
}

@end
