//
//  PatchCabler.m
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PatchCabler.h"

@implementation PatchCabler
{
    NSColor *_shadowColor;
}
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        endpoints = [[NSMutableDictionary alloc] init];
        _shadowColor = [NSColor colorWithSRGBRed:60/255.0 green:104/255.0 blue:205/255.0 alpha:1.0];
        

    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    
    
    [endpoints enumerateKeysAndObjectsUsingBlock:^(id parameterName, id endpoint, BOOL *stop)
    {
        [context saveGraphicsState];

        NSBezierPath *cablePath = [[NSBezierPath alloc] init];
        [cablePath setLineWidth:4];

        NSPoint orig = [endpoint origin];
        NSPoint loc = [endpoint frame].origin;
        


    
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
            orig.y += 4;

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
            NSPoint final;
        
            // calculate final point
            float d = (loc.y+[endpoint size].height/2) - orig.y;
            
            if ([endpoint connectedTo] && [[endpoint connectedTo] cablerEdge] == kEdgeRight) {
                final = NSMakePoint(loc.x + 4,
                                    loc.y + [endpoint size].height/2);
            }
            else
            if ([endpoint connectedTo] && [[endpoint connectedTo] cablerEdge] == kEdgeLeft) {
                final = NSMakePoint(loc.x + [endpoint size].width - 4,
                                    loc.y + [endpoint size].height/2);
            }
            else
            if (fabs(d) < 4) {
                final = NSMakePoint(loc.x + 4,
                                    loc.y + [endpoint size].height/2);
            } else
            if (d < 0) {
                final = NSMakePoint(loc.x + [endpoint size].width/2,
                                    loc.y + [endpoint size].height-4);
            }
            else {
                final = NSMakePoint(loc.x + [endpoint size].width/2,
                                    loc.y+4);
            }

            

            // add any necessary midpoints
            if ([endpoint connectedTo]) {
                int connectedEdge = [[endpoint connectedTo] cablerEdge];
                if (connectedEdge == kEdgeLeft || connectedEdge == kEdgeRight) {
                    double h = orig.y / [self bounds].size.height;

                    if (connectedEdge == [endpoint cablerEdge]) {
                        //connected to same edge
                        double x = connectedEdge == kEdgeLeft ? 100 : [self bounds].size.width-100;
                        x += 70*h;
                        [cablePath lineToPoint:NSMakePoint(x, orig.y)];
                        [cablePath lineToPoint:NSMakePoint(x, final.y)];
                    
                    } else {
                        //connected to opposite edge
                        double x = fabs((final.x - orig.x) / 2); // midpoint
                        x += connectedEdge == kEdgeLeft ? 70 : 90 *h;
                        
                        NSPoint mid = NSMakePoint(x, orig.y);
                        [cablePath lineToPoint:mid];
                        [cablePath lineToPoint:NSMakePoint(mid.x, final.y)];
                        
                    }
                }
                else {
                    //connected to adjacent edge
                    [cablePath lineToPoint:NSMakePoint(final.x, orig.y)];
                }


                

            }
            else {
                // being dragged
                [cablePath lineToPoint:NSMakePoint(final.x, orig.y)];
                
            }


            //connect to final point
            [cablePath lineToPoint:final];


        }
        
        [[endpoint color] set];
        [cablePath stroke];

        [context restoreGraphicsState];

    }];


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
    [self connect_endpoints:source :target];
    [self setNeedsDisplay:YES];

}
- (void)disconnectEndpoints:(NSString*)sourceName :(NSString*)targetName
{
    PatchCableEndpoint *source = [endpoints objectForKey:sourceName];
    PatchCableEndpoint *target = [endpoints objectForKey:targetName ];
    [self disconnect_endpoints:source :target];

    [self setNeedsDisplay:YES];

}

- (void)connect_endpoints:(PatchCableEndpoint*)source :(PatchCableEndpoint*)target
{
    [source setConnectedTo:target];
    
    if (target && ![target->inputs containsObject:source]) {
        [target->inputs addObject:source];
    }
}
- (void)disconnect_endpoints:(PatchCableEndpoint*)source :(PatchCableEndpoint*)target
{
    if (target && source && [target endpointType] == kInputPatchEndpoint)
        [target->inputs removeObject:source];
    
    for (int i=0; i < [target->inputs count]; i++) {
        [[target->inputs objectAtIndex:i] setConnectionCount:i+1];
    }
    
    [source setConnectedTo:nil];
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
            
            [self connect_endpoints:sender :target];

            if (delegate) {
                [delegate patchConnected:sender :target];
            }
            
        }
    }];
}
- (void)endpointReleased:(id)sender fromEndpoint:(id)connectedTo
{
    [self disconnect_endpoints:connectedTo :sender];
    if (delegate) {
        [delegate patchDisconnected:connectedTo :sender];
    }

}

@end
