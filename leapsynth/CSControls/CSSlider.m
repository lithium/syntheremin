//
//  CSSlider.m
//  leapsynth
//
//  Created by Wiggins on 10/24/13.
//
//

#import "CSSlider.h"

@implementation CSSlider

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
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
