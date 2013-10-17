//
//  PatchCabler.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PatchCableEndpoint.h"


@protocol PatchCablerDelegate <NSObject>
- (void)patchConnected:(PatchCableEndpoint *)source :(PatchCableEndpoint *)target;
- (void)patchDisconnected:(PatchCableEndpoint *)source :(PatchCableEndpoint *)target;
@end


@interface PatchCabler : NSView <PatchCableEndpointDelegate> 
{
    NSImage *outputImage, *inputImage;
    NSMutableArray *endpoints;
    
}
@property (weak) id <PatchCablerDelegate> delegate;

- (int)addEndpoint:(PatchCableEndpoint *)endpoint;

- (int)addEndpointWithType:(int)endpointType 
          andParameterName:(NSString*)name
                    onEdge:(int)cablerEdge
                withOffset:(double)edgeOffset
                          ;

@end
