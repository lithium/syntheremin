//
//  CSToggleButton.m
//  leapsynth
//
//  Created by Wiggins on 10/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSToggleButton.h"

@implementation CSToggleButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)setButtonName:(NSString*)name
{
    offImage = [NSImage imageNamed:[NSString stringWithFormat:@"button_%@", name]];
    onImage = [NSImage imageNamed:[NSString stringWithFormat:@"button_%@_selected", name]];

    [self setNeedsDisplay:YES];
}

- (BOOL)toggled { return [self doubleValue] == 1.0; }

- (void)setToggled:(BOOL)flag 
{
    if (flag)
        [self setDoubleValue:1.0];
    else {
        [self setDoubleValue:0];
    }
}
    

- (void)drawRect:(NSRect)dirtyRect
{
    CGRect bounds = [self bounds];
    
    NSImage *image = [self toggled] ? onImage : offImage;
    
    [image drawInRect:bounds
                  fromRect:NSMakeRect(0,0, [image size].width, [image size].height)
                 operation:NSCompositeSourceOver
                  fraction:1.0];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    pressed = YES;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint windowLocation = [_window convertScreenToBase:[NSEvent mouseLocation]];

    if (pressed && NSPointInRect(windowLocation, self.frame)) {
        
        [self setToggled:![self toggled]];
        pressed = NO;
    }
}
@end
