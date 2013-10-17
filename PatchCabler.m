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
        
        NSPoint orig = [draggingEndpoint origin];
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
    PatchCableEndpoint *endpoint = [[PatchCableEndpoint alloc] initWithType:endpointType
                                                                    andName:name
                                                                     onEdge:cablerEdge
                                                                 withOffset:edgeOffset
                                                               parentBounds:[self bounds]];
    
    return [self addEndpoint:endpoint];
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
