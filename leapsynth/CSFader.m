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
        trackImage = [NSImage imageNamed:@"slider_background"];
        knobImage = [NSImage imageNamed:@"slider_handle"];
        NSImage *glow = [NSImage imageNamed:@"slider_glow"];

        
        glowSize = [glow size];
        NSSize capSize = NSMakeSize(glowSize.width, glowSize.height/2);
        
        glowTop = [[NSImage alloc] initWithSize:capSize];
        glowBottom = [[NSImage alloc] initWithSize:capSize];
        glowCenter = [[NSImage alloc] initWithSize:NSMakeSize(glowSize.width, 2)];

        
        [glowBottom lockFocus];
        [glow compositeToPoint:NSMakePoint(0,0) 
                      fromRect:NSMakeRect(0,0,
                                          glowSize.width,glowSize.height/2)
                     operation:NSCompositeSourceOver];
        [glowBottom unlockFocus];

        [glowTop lockFocus];
        [glow compositeToPoint:NSMakePoint(0,0) 
                      fromRect:NSMakeRect(0,glowSize.height/2,
                                          glowSize.width,glowSize.height/2)
                     operation:NSCompositeSourceOver];
        [glowTop unlockFocus];
        
        [glowCenter lockFocus];
        [glow compositeToPoint:NSMakePoint(0,0)
                      fromRect:NSMakeRect(0,glowSize.height/2,
                                          glowSize.width,2)
                     operation:NSCompositeSourceOver];
        [glowCenter unlockFocus];

        knobWidth = [knobImage size].width;
        knobHeight = [knobImage size].height;
        
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
    
    
    double glowHeight = bounds.size.height*[self normalizeValue];
    if ([self normalizeValue] < 0.6) {
        glowHeight += glowSize.height/2;
    }
                     
    NSDrawThreePartImage(NSMakeRect(bounds.size.width/2 - glowSize.width/2,
                                    0,
                                    glowSize.width, 
                                    glowHeight),
                         glowTop, glowCenter, glowBottom, 
                         YES, NSCompositeSourceOver, 1.0, NO);
    
    
    [knobImage drawInRect:NSMakeRect(bounds.size.width/2 - knobWidth/2, 
                                     (bounds.size.height-knobHeight)*[self normalizeValue], 
                                     knobWidth, knobHeight)
                 fromRect:NSMakeRect(0,0, [knobImage size].width, [knobImage size].height)
                operation:NSCompositeSourceOver
                 fraction:1.0];
    
}


- (void)setValueFromScreenLocation:(NSPoint)screenLocation
{
    NSPoint windowLocation = [_window convertScreenToBase:screenLocation];
    NSPoint loc = [self convertPoint:windowLocation fromView:nil];
    double val = loc.y / [self bounds].size.height;
    [self setDoubleValue:val];
    [self setNeedsDisplay:YES];

}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (!dragging)
        return;
    [self setValueFromScreenLocation:[NSEvent mouseLocation]];
}
- (void)mouseDown:(NSEvent *)theEvent
{
    dragging = YES;
    [self setValueFromScreenLocation:[NSEvent mouseLocation]];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    dragging = NO;
}

@end
