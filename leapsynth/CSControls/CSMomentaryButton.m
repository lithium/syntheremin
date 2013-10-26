//
//  CSPushButton.m
//  leapsynth
//
//  Created by Wiggins on 10/26/13.
//
//

#import "CSMomentaryButton.h"

@implementation CSMomentaryButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)mouseDown:(NSEvent *)theEvent
{
    [self setToggled:YES];
    
    theEvent = [[self window] nextEventMatchingMask:NSLeftMouseUpMask];
    NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if ([self mouse:mouseLoc inRect:[self bounds]]) {
        [self performAction];
    }
    [self setToggled:NO];

}

- (void)mouseUp:(NSEvent *)theEvent
{
//    [self setToggled:NO];
}
@end
