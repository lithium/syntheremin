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
@synthesize size;
@synthesize color;


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
         withColor:(NSColor*)aColor
      parentBounds:(NSRect)bounds
{
    _padding = 4;
    size = NSMakeSize(kOutputEndpointWidth+_padding*2, kOutputEndpointHeight+_padding*2);
    if (type == kInputPatchEndpoint) {
        size = NSMakeSize(kInputEndpointWidth+_padding*2, kInputEndpointHeight+_padding*2);
    }

#define kStemLength 20
    
    double x,y;
    switch (edge) {
        case kEdgeLeft:
            x = kStemLength;
            y = offset > 0 ? offset : bounds.size.height+offset;
            break;
        case kEdgeTop:
            x = offset > 0 ? offset : bounds.size.width+offset;
            y = bounds.size.height-size.height - kStemLength;
            break;
        case kEdgeRight:
            x = bounds.size.width-size.width - kStemLength;
            y = offset > 0 ? offset : bounds.size.height+offset;
            break;
        case kEdgeBottom:
            x = offset > 0 ? offset : bounds.size.width+offset;
            y = kStemLength;
            break;
    }
    origin = NSMakePoint(x,y);
    

    self = [self initWithFrame:NSMakeRect(x, y, size.width, size.height)];

    
    [self setCablerEdge:edge];
    [self setEdgeOffset:offset];
    [self setEndpointType:type];
    [self setParameterName:name];
    [self setColor:aColor];

    return self;
}

   
- (int)endpointType { return endpointType; }
- (void)setEndpointType:(int)newEndpointType
{
    endpointType = newEndpointType;
    if (endpointType == kOutputPatchEndpoint) {
        image = [NSImage imageNamed:@"wire_out"];
    } else {
        image = [NSImage imageNamed:@"wire_in"];
    }
}

- (id)connectedTo { return connectedTo; }
- (void)setConnectedTo:(id)target
{

    
    connectedTo = target;
    isConnected = (target != nil);
    isDragging = NO;
    
    
    
    if (endpointType == kOutputPatchEndpoint) {
        if (!isConnected) {
            [self setFrameOrigin:origin];
        } else {
            
            int connectedCount = [self target]->_connectedCount;

            double x = [target origin].x;
            double y = [target origin].y + size.height/2;
            
            if (connectedCount == 2) {
                y += 5;
            }
            if (connectedCount == 3) {
                y -= 5;
            }

            if ([target cablerEdge] == kEdgeRight) {
                y -= _padding;
                x -= _padding;
            }
            else
            if ([target cablerEdge] == kEdgeLeft) {
                y -= _padding;
                x += _padding;
            }

            [self setFrameOrigin:NSMakePoint(x,y)];

        }
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
            rads = M_PI;
            break;
        case kEdgeTop:
            rads = 1.5*M_PI;
            break;
        case kEdgeRight:
            rads = 0;
            break;
        case kEdgeBottom:
            rads = 1.5*M_PI;
            break;
    }
    [rotate rotateByRadians:rads];
    [rotate translateXBy:-(bounds.size.width/2) yBy:-(bounds.size.height/2)];
    [rotate concat];

    NSBezierPath *path = [[NSBezierPath alloc] init];
    
    if (endpointType == kOutputPatchEndpoint) {
        [path appendBezierPathWithOvalInRect:NSMakeRect(_padding, _padding,
                                                        kOutputEndpointWidth,
                                                        kOutputEndpointHeight)];
    } else {
        [path appendBezierPathWithArcWithCenter:NSMakePoint(bounds.size.width/2, bounds.size.height/2)
                                         radius:bounds.size.width/2-_padding
                                     startAngle:90
                                       endAngle:270
                                      clockwise:YES];
//        [path appendBezierPathWithOvalInRect:NSMakeRect(_padding,_padding,
//                                                        kInputEndpointWidth,
//                                                        kInputEndpointHeight)];
//        [path appendBezierPathWithOvalInRect:NSMakeRect(_padding, _padding,
//                                                        kInputEndpointWidth, kInputEndpointWidth)];
        
    }
    [color set];
    
    [path setLineWidth:4];
    [path stroke];
//    [image drawInRect:bounds
//             fromRect:NSMakeRect(0, 0, [image size].width, [image size].height)
//            operation:NSCompositeSourceOver
//             fraction:1.0];
    
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
            _connectedCount = 0;
        }
    } 
    else if (endpointType == kOutputPatchEndpoint) 
    {
        [self setFrameOrigin:origin];        
        isDragging = YES;
    }
    
    [[self superview] setNeedsDisplay:YES];

}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (!isDragging)
        return;
    
    isDragging = NO;
    
    if (delegate) {
        [delegate endpointReleased:self fromEndpoint:connectedTo];
    }

    if (!isConnected) {
        [self setFrameOrigin:origin];
        if ([self target]) {
            [self target]->_connectedCount--;
            [[self target] setConnectedTo:nil];
        }
        [self setConnectedTo:nil];
    }
    [[self superview] setNeedsDisplay:YES];

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
