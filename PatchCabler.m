//
//  PatchCabler.m
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PatchCabler.h"

@implementation PatchCabler

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        endpoints = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    
//    NSRect bounds = [self bounds];
    [context saveGraphicsState];
    
    if (draggingEndpoint) {
        NSBezierPath *cablePath = [[NSBezierPath alloc] init];
        [cablePath setLineWidth:4];
        
        NSPoint orig = [draggingEndpoint startingPoint];
        orig.y += kEndpointHeight/2;
        NSPoint loc = [draggingEndpoint frame].origin;
        loc.y += kEndpointHeight/2;

        [cablePath moveToPoint:orig];
        [cablePath lineToPoint:loc];
        [[NSColor blackColor] set];
        [cablePath stroke];
        
        NSLog(@"%f,%f -> %f,%f", orig.x, orig.y, loc.x, loc.y);

    }
    
    [context restoreGraphicsState];
}


- (int)addEndpointWithType:(int)endpointType 
          andParameterName:(NSString*)name
                    onEdge:(int)cablerEdge
                withOffset:(double)edgeOffset
{
    NSRect bounds = [self bounds];
    double x,y;
    
    switch (cablerEdge) {
        case kEdgeLeft:
            x = 0;
            y = edgeOffset > 0 ? edgeOffset : bounds.size.height+edgeOffset;
            break;
        case kEdgeTop:
            x = edgeOffset > 0 ? edgeOffset : bounds.size.width+edgeOffset;
            y = bounds.size.height-kEndpointHeight;
            break;
        case kEdgeRight:
            x = bounds.size.width-kEndpointWidth;
            y = edgeOffset > 0 ? edgeOffset : bounds.size.height+edgeOffset;
            break;
        case kEdgeBottom:
            x = edgeOffset > 0 ? edgeOffset : bounds.size.width+edgeOffset;
            y = 0;
            break;
    }
    NSRect endpointFrame = NSMakeRect(x, y, kEndpointWidth, kEndpointHeight);
    PatchCableEndpoint *newEndpoint = [[PatchCableEndpoint alloc] initWithFrame:endpointFrame];
    [newEndpoint setEndpointType:endpointType];
    [newEndpoint setParameterName:name];
    [newEndpoint setCablerEdge:cablerEdge];
    [newEndpoint setEdgeOffset:edgeOffset];
    
    return [self addEndpoint:newEndpoint];
}
- (int)addEndpoint:(PatchCableEndpoint *)newEndpoint
{
    [newEndpoint setDelegate:self];
    [self addSubview:newEndpoint];
    
    [endpoints addObject:newEndpoint];
    return [endpoints indexOfObject:newEndpoint];

}

- (void)endpointDragged:(id)sender
{
    draggingEndpoint = (PatchCableEndpoint*)sender;
    [self setNeedsDisplay:YES];
}
- (void)endpointReleased:(id)sender
{
    draggingEndpoint = nil;
    [self setNeedsDisplay:YES];

}

@end
