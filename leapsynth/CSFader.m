//
//  CSFader.m
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSFader.h"

@implementation CSFader

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        trackImage = [NSImage imageNamed:@"csfader_bg.png"];
        knobImage = [NSImage imageNamed:@"csfader_knob.png"];
        
        NSRect bounds = [self bounds];
        knobWidth = bounds.size.width*0.5;
        knobHeight = bounds.size.height*.1;
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGRect bounds = [self bounds];
    
    [trackImage drawInRect:bounds
                  fromRect:NSMakeRect(0,0, [trackImage size].width, [trackImage size].height)
                 operation:NSCompositeSourceOver
                  fraction:1.0];
    
    
    [knobImage drawInRect:NSMakeRect(bounds.size.width/2 - knobWidth/2, 
                                     (bounds.size.height-knobHeight)*[self normalizeValue], 
                                     knobWidth, knobHeight)
                 fromRect:NSMakeRect(0,0, [knobImage size].width, [knobImage size].height)
                operation:NSCompositeSourceOver
                 fraction:1.0];
    
}

@end
