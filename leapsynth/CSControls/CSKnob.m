//
//  CSKnob.m
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSKnob.h"

@implementation CSKnob

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        knobImage = [NSImage imageNamed:@"knob_dial"];
        trackImage = [NSImage imageNamed:@"knob_outerRing_empty"];
        fillImage = [NSImage imageNamed:@"knob_outerRing_full"];

        knobSize = [knobImage size];
        trackSize = [trackImage size];

        minValue = 0;
        maxValue = 1.0;
        
    }
    
    return self;
}

- (void)setDoubleValue:(double)newValue
{
    [super setDoubleValue:newValue];
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    CGRect bounds = [self bounds];
    double rads = [self normalizeValue] * kRadianRange - kKnobRangeMin;

    
    //draw empty track
    [context saveGraphicsState];
    [trackImage drawInRect:bounds
                  fromRect:NSMakeRect(0,0, [trackImage size].width, [trackImage size].height)
                 operation:NSCompositeSourceOver
                  fraction:1.0];
    
    
#define startDegree 230
#define stopDegree 280
    
    //build the mask
    NSBezierPath *maskPath = [[NSBezierPath alloc] init];
    NSPoint center = NSMakePoint(bounds.size.width/2,bounds.size.height/2);
    [maskPath setLineWidth:6.0];
    [maskPath moveToPoint:center];
    [maskPath appendBezierPathWithArcWithCenter:center
                                         radius:bounds.size.width/2 
                                     startAngle:startDegree
                                       endAngle:startDegree-stopDegree*[self normalizeValue]
                                      clockwise:YES];
    [maskPath closePath];

//    [maskPath fill];
    //draw the fill clipped with mask
    [maskPath addClip];
    [fillImage drawInRect:bounds
                  fromRect:NSMakeRect(0,0, [trackImage size].width, [trackImage size].height)
                 operation:NSCompositeSourceOver
                  fraction:1.0];
    
    [context restoreGraphicsState];

    
    
    //draw rotated knob
    [context saveGraphicsState];
    
    NSAffineTransform *rotate = [[NSAffineTransform alloc] init];
    [rotate translateXBy:knobSize.width/2 yBy:knobSize.height/2];
    [rotate rotateByRadians:-rads];
    [rotate translateXBy:-(knobSize.width/2) yBy:-(knobSize.height/2)];
    [rotate concat];
    
    [knobImage drawInRect:NSMakeRect((bounds.size.width - knobSize.width)/2,
                                     (bounds.size.height - knobSize.height)/2, 
                                     knobSize.width, knobSize.height)
             fromRect:NSMakeRect(0, 0, [knobImage size].width, [knobImage size].height)
            operation:NSCompositeSourceOver
             fraction:1.0];
    [context restoreGraphicsState];
    
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
    double normal = (pos.y - lastDragPoint.y) / dragModifier;
    double unit = (maxValue - minValue) / dragModifier;
    double distance = normal*unit;
    
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
