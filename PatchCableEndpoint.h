//
//  PatchCableEndpoint.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kEndpointWidth 32
#define kEndpointHeight 32

enum {
    kInputPatchEndpoint=0,
    kOutputPatchEndpoint=1,
};

enum {
    kEdgeLeft,
    kEdgeTop,
    kEdgeRight,
    kEdgeBottom,
};

@protocol PatchCableEndpointDelegate <NSObject>

- (void)endpointDragged:(id)endpoint toLocation:(NSPoint)dragLocation;
- (void)endpointReleased:(id)endpoint;

@end

@interface PatchCableEndpoint : NSView
{
    int endpointType;
    
    
    NSImage *image;    
    
    BOOL isConnected;
    __weak id connectedTo;

    NSPoint clickLocation;
    NSPoint dragOrigin;
    NSPoint origin;
}

@property BOOL isDragging;
@property int endpointType;
@property NSString *parameterName;
@property int cablerEdge;
@property double edgeOffset;
@property (weak) id <PatchCableEndpointDelegate> delegate;
@property (weak) id connectedTo;

- (NSPoint)origin;

- (id)initWithType:(int)endpointType 
           andName:(NSString*)name
            onEdge:(int)edge
        withOffset:(double)offset
      parentBounds:(NSRect)bounds
                  ;

@end
