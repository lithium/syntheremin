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
//    NSGraphicsContext *context = [NSGraphicsContext currentContext];
//    
//    NSRect bounds = [self bounds];
//    [context saveGraphicsState];
//    
//    [context restoreGraphicsState];
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
    
    [self addSubview:newEndpoint];
    
    [endpoints addObject:newEndpoint];
    return [endpoints indexOfObject:newEndpoint];
}
- (int)addEndpoint:(PatchCableEndpoint *)newEndpoint
{

}

@end
