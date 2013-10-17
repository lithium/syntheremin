//
//  PatchCabler.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PatchCableEndpoint.h"
#define kEndpointWidth 32
#define kEndpointHeight 32


@interface PatchCabler : NSView <PatchCableEndpointDelegate> 
{
    NSImage *outputImage, *inputImage;
    NSMutableArray *endpoints;
    
    __weak PatchCableEndpoint *draggingEndpoint;
}

- (int)addEndpoint:(PatchCableEndpoint *)endpoint;

- (int)addEndpointWithType:(int)endpointType 
          andParameterName:(NSString*)name
                    onEdge:(int)cablerEdge
                withOffset:(double)edgeOffset
                          ;

@end
