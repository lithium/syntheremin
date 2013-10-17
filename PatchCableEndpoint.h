//
//  PatchCableEndpoint.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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

- (void)endpointDragged:(id)endpoint;
- (void)endpointReleased:(id)endpoint;

@end

@interface PatchCableEndpoint : NSView
{
    int endpointType;
    
   
    NSImage *image;    
    BOOL isConnected;
    BOOL isDragging;
    NSPoint clickLocation;
    NSPoint origOrigin;
}

@property int endpointType;
@property NSString *parameterName;
@property int cablerEdge;
@property double edgeOffset;
@property (weak) id <PatchCableEndpointDelegate> delegate;

- (NSPoint)startingPoint;
@end
