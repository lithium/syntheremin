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
    
    [endpoints enumerateKeysAndObjectsUsingBlock:^(id parameterName, id endpoint, BOOL *stop)
    {
        NSBezierPath *cablePath = [[NSBezierPath alloc] init];
        [cablePath setLineWidth:4];

        NSPoint orig = [endpoint origin];
        NSPoint loc = [endpoint frame].origin;
        


    
//        [cablePath moveToPoint:orig];
//        orig.x += 5;
//        [cablePath lineToPoint:orig];
        
//        if ([endpoint cablerEdge] == kEdgeRight) {
            orig.x += 4;
//        }

        
        if ([endpoint endpointType] == kOutputPatchEndpoint ||
            [endpoint connectedTo] != nil ||
            [endpoint isDragging])
        {
            
            orig.y += [endpoint size].height/2;
            loc.y += [endpoint size].height/2;
            
//            loc.x += [endpoint cablerEdge] == kEdgeLeft ? -5 : 5;
            if ([endpoint cablerEdge] == kEdgeLeft) {
                loc.x += 5;
            }
            else if ([endpoint cablerEdge] == kEdgeRight) {
                orig.x += kOutputEndpointWidth;
                loc.x += kOutputEndpointWidth+2;
            }
            
            [cablePath moveToPoint:orig];
            [cablePath lineToPoint:loc];
        }
        
        [[endpoint color] set];
        [cablePath stroke];

    }];


    [context restoreGraphicsState];
}


- (void)addEndpointWithType:(int)endpointType 
          andParameterName:(NSString*)name
                    onEdge:(int)cablerEdge
                withOffset:(double)edgeOffset
                  withColor:(NSColor*)color
{
    PatchCableEndpoint *endpoint = [[PatchCableEndpoint alloc] initWithType:endpointType
                                                                    andName:name
                                                                     onEdge:cablerEdge
                                                                 withOffset:edgeOffset
                                                                  withColor:color
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
    
        NSArray *targetParts = [[target parameterName] componentsSeparatedByString:@":"];
        NSArray *senderParts = [[sender parameterName] componentsSeparatedByString:@":"];
        
        if (target != sender &&
            !([targetParts[0] isEqualToString:senderParts[0]] && [targetParts[1] isEqualToString:senderParts[1]]) &&
            NSPointInRect(dragLocation,[target frame]) &&
            [target endpointType] == kInputPatchEndpoint)
        {
            NSLog(@"target %@ sender %@", targetParts, senderParts);

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
