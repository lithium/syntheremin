//
//  PatchCabler.m
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PatchCabler.h"

@implementation PatchCabler
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        endpoints = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    
    [context saveGraphicsState];
    
    NSBezierPath *cablePath = [[NSBezierPath alloc] init];
    [cablePath setLineWidth:4];
    [endpoints enumerateKeysAndObjectsUsingBlock:^(id parameterName, id endpoint, BOOL *stop) {
        
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
    
    }];

    [[NSColor blackColor] set];
    [cablePath stroke];

    [context restoreGraphicsState];
}


- (void)addEndpointWithType:(int)endpointType 
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
- (void)addEndpoint:(PatchCableEndpoint *)newEndpoint
{
    [self addSubview:newEndpoint];
    [newEndpoint setDelegate:self];
    
    [endpoints setObject:newEndpoint forKey:[newEndpoint parameterName]];
}
- (void)connectEndpoints:(NSString*)sourceName :(NSString*)targetName
{  
    PatchCableEndpoint *source = [endpoints objectForKey:sourceName];
    PatchCableEndpoint *target = [endpoints objectForKey:targetName ];
    [source setConnectedTo:target];
    [target setConnectedTo:source];
    [self setNeedsDisplay:YES];
    
}
- (void)disconnectEndpoints:(NSString*)sourceName :(NSString*)targetName
{
    PatchCableEndpoint *source = [endpoints objectForKey:sourceName];
    PatchCableEndpoint *target = [endpoints objectForKey:targetName ];
    [source setConnectedTo:nil];
    [target setConnectedTo:nil];
    [self setNeedsDisplay:YES];

}

- (void)endpointDragged:(id)sender toLocation:(NSPoint)dragLocation
{
    dragLocation = [self convertPoint:dragLocation fromView:nil];
    [endpoints enumerateKeysAndObjectsUsingBlock:^(id key, id target, BOOL *stop) {
    
        if (target != sender && 
            NSPointInRect(dragLocation,[target frame]) &&
            [target endpointType] == kInputPatchEndpoint) 
        {
            PatchCableEndpoint *source = (PatchCableEndpoint*)sender;
            [source setConnectedTo:target];
            [target setConnectedTo:source];
            
            if (delegate) {
                [delegate patchConnected:source :target];
            }
            
        }
    }];
}
- (void)endpointReleased:(id)sender fromEndpoint:(id)connectedTo
{
    if (delegate) {
        [delegate patchDisconnected:sender :connectedTo];
    }

}

@end
