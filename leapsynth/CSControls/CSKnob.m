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
        image = [NSImage imageNamed:@"csknob_knob.png"];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setAlignment:NSCenterTextAlignment];
        labelAttributes = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
        
        minValue = 0;
        maxValue = 1.0;
        
        NSRect bounds = [self bounds];
        labelRect = NSMakeRect(0, bounds.size.height/2- kLabelHeight/2, bounds.size.width, kLabelHeight);
    }
    
    return self;
}

- (void)setDoubleValue:(double)newValue
{
    [super setDoubleValue:newValue];
    
    label = [NSString stringWithFormat:@"%.2f", value];
}


- (void)drawRect:(NSRect)dirtyRect
{
    CGRect bounds = [self bounds];
    NSAffineTransform *rotate = [[NSAffineTransform alloc] init];
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    
    //draw rotated knob
    [context saveGraphicsState];
    [rotate translateXBy:bounds.size.width/2 yBy:bounds.size.height/2];
    double rads = [self normalizeValue] * kRadianRange - kKnobRangeMin;
    [rotate rotateByRadians:-rads];
    [rotate translateXBy:-(bounds.size.width/2) yBy:-(bounds.size.height/2)];
    [rotate concat];
    
    [image drawInRect:bounds
             fromRect:NSMakeRect(0, 0, [image size].width, [image size].height)
            operation:NSCompositeSourceOver
             fraction:1.0];
    [context restoreGraphicsState];
    
    //draw label if dragging
    if (dragging) {
        [context saveGraphicsState];
        
        [[NSColor redColor] set];
        [label drawInRect:labelRect withAttributes:labelAttributes];
        [context restoreGraphicsState];
    }
}
@end
