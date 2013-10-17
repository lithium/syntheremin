//
//  PatchCableEndpoint.m
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PatchCableEndpoint.h"


@implementation PatchCableEndpoint
@synthesize parameterName;
@synthesize cablerEdge;
@synthesize edgeOffset;
@synthesize isDragging;
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setEndpointType:kOutputPatchEndpoint];
    }
    
    return self;
}

- (id)initWithType:(int)type 
           andName:(NSString*)name
            onEdge:(int)edge
        withOffset:(double)offset
      parentBounds:(NSRect)bounds
{
    
    double x,y;
    switch (edge) {
        case kEdgeLeft:
            x = 0;
            y = offset > 0 ? offset : bounds.size.height+offset;
            break;
        case kEdgeTop:
            x = offset > 0 ? offset : bounds.size.width+offset;
            y = bounds.size.height-kEndpointHeight;
            break;
        case kEdgeRight:
            x = bounds.size.width-kEndpointWidth;
            y = offset > 0 ? offset : bounds.size.height+offset;
            break;
        case kEdgeBottom:
            x = offset > 0 ? offset : bounds.size.width+offset;
            y = 0;
            break;
    }
    origin = NSMakePoint(x,y);
    self = [self initWithFrame:NSMakeRect(x, y, kEndpointWidth, kEndpointHeight)];

    
    [self setCablerEdge:edge];
    [self setEdgeOffset:offset];
    [self setEndpointType:type];
    [self setParameterName:name];

    return self;
}

   
- (int)endpointType { return endpointType; }
- (void)setEndpointType:(int)newEndpointType
{
    endpointType = newEndpointType;
    if (endpointType == kOutputPatchEndpoint) {
        image = [NSImage imageNamed:@"patch_endpoint_output.png"];
    } else {
        image = [NSImage imageNamed:@"patch_endpoint_input.png"];
    }
}

- (id)connectedTo { return connectedTo; }
- (void)setConnectedTo:(id)target
{
    connectedTo = target;
    isConnected = (target != nil);
    isDragging = NO;
    if (!isConnected) {
        [self setFrameOrigin:origin];        
    }
}

- (NSPoint)origin 
{
    return origin;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    NSAffineTransform *rotate = [[NSAffineTransform alloc] init];
    NSRect bounds = [self bounds];
    
    [context saveGraphicsState];
    [rotate translateXBy:bounds.size.width/2 yBy:bounds.size.height/2];
    double rads = M_PI/2;
    switch (cablerEdge) {
        case kEdgeLeft:
            rads = 0;
            break;
        case kEdgeTop:
            rads = 1.5*M_PI;
            break;
        case kEdgeRight:
            rads = M_PI;
            break;
        case kEdgeBottom:
            rads = M_PI/2;
            break;
    }
    [rotate rotateByRadians:rads];
    [rotate translateXBy:-(bounds.size.width/2) yBy:-(bounds.size.height/2)];
    [rotate concat];

    
    [image drawInRect:bounds
             fromRect:NSMakeRect(0, 0, [image size].width, [image size].height)
            operation:NSCompositeSourceOver
             fraction:1.0];
    [context restoreGraphicsState];
    
}

- (PatchCableEndpoint*)target
{
    return (PatchCableEndpoint*)connectedTo;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    dragOrigin = [self frame].origin;
    clickLocation = [theEvent locationInWindow];

    if (endpointType == kInputPatchEndpoint) 
    {
        if (isConnected) {
            if (delegate) {
                [delegate endpointReleased:connectedTo fromEndpoint:self];
            }
            [[self target] setConnectedTo:nil];
            [self setConnectedTo:nil];
            [[self superview] setNeedsDisplay:YES];
        }
        return;
    } 
    else if (endpointType == kOutputPatchEndpoint) 
    {
        [self setConnectedTo:nil];
        isDragging = YES;
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (!isDragging)
        return;
    isDragging = NO;
    if (!isConnected) {
        [self setFrameOrigin:origin];
    }
    [[self superview] setNeedsDisplay:YES];
    if (delegate) {
        [delegate endpointReleased:self fromEndpoint:nil];
    }

}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (!isDragging)
        return;
    NSPoint dragLocation = [theEvent locationInWindow];
    [self setFrameOrigin:NSMakePoint(dragOrigin.x + (dragLocation.x - clickLocation.x), 
                                     dragOrigin.y + (dragLocation.y - clickLocation.y))];
    [[self superview] setNeedsDisplay:YES];

    if (delegate) {
        [delegate endpointDragged:self toLocation:dragLocation];
    }
}
@end
