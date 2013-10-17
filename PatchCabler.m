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
    
    [context saveGraphicsState];
    
    NSBezierPath *cablePath = [[NSBezierPath alloc] init];
    [cablePath setLineWidth:4];
    for (PatchCableEndpoint *endpoint in endpoints) {
        if ([endpoint endpointType] == kOutputPatchEndpoint ||
            [endpoint connectedTo] != nil ||
            [endpoint isDragging])
        {
            NSPoint orig = [endpoint origin];
            orig.y += kEndpointHeight/2;
            NSPoint loc = [endpoint frame].origin;
            loc.y += kEndpointHeight/2;
            
            [cablePath moveToPoint:orig];
            [cablePath lineToPoint:loc];
        }
    }
    [[NSColor blackColor] set];
    [cablePath stroke];

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
    [self addSubview:newEndpoint];
    
    [endpoints addObject:newEndpoint];
    return [endpoints indexOfObject:newEndpoint];

}


@end
