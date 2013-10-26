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
        

        //draw the stem
        if ([endpoint cablerEdge] == kEdgeLeft) {
            orig.x += 4;
            orig.y += [endpoint size].height/2;

            [cablePath moveToPoint:NSMakePoint(0, orig.y)];
            [cablePath lineToPoint:NSMakePoint(orig.x, orig.y)];
        } else if ([endpoint cablerEdge] == kEdgeRight) {
            orig.x += [endpoint size].width-4;
            orig.y += [endpoint size].height/2;

            [cablePath moveToPoint:NSMakePoint([self bounds].size.width, orig.y)];
            [cablePath lineToPoint:NSMakePoint(orig.x, orig.y)];

        } else if ([endpoint cablerEdge] == kEdgeBottom) {
            orig.x += [endpoint size].width/2;
            orig.y += [endpoint size].height/2-4;

            [cablePath moveToPoint:NSMakePoint(orig.x, 0)];
            [cablePath lineToPoint:NSMakePoint(orig.x, orig.y)];

        } else {
            [cablePath moveToPoint:orig];
        }
        [[endpoint color] set];
        [cablePath stroke];

        
        
        
        if ([endpoint endpointType] == kOutputPatchEndpoint &&
            ([endpoint connectedTo] != nil || [endpoint isDragging]))
        {
            
//            loc.y += [endpoint size].height/2;
            loc.y += [endpoint size].height-4;

            
            if ([endpoint cablerEdge] == kEdgeLeft) {
                
                loc.x += [endpoint size].width/2;

            }
            else if ([endpoint cablerEdge] == kEdgeRight) {
                orig.x += [endpoint size].width;
                loc.x += [endpoint size].width-4;
            }
            
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
