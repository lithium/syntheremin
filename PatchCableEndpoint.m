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

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setEndpointType:kOutputPatchEndpoint];
    }
    
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

@end
