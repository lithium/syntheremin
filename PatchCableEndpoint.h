//
//  PatchCableEndpoint.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOutputEndpointWidth 13
#define kOutputEndpointHeight 13

#define kInputEndpointWidth 21
#define kInputEndpointHeight 21

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
- (void)endpointReleased:(id)sender fromEndpoint:(id)connectedTo;

@end

@interface PatchCableEndpoint : NSView
{
    int endpointType;
    
    int _padding;
    
    NSImage *image;    
    
    BOOL isConnected;
    __weak id connectedTo;

    NSPoint clickLocation;
    NSPoint dragOrigin;
    NSPoint origin;
    
    NSSize size;
    NSImage *orbImage;
    
    @public
    
    
    NSMutableArray *inputs; // the output endpoints that are connected to us
}

@property NSColor *color;
@property BOOL isDragging;
@property int endpointType;
@property NSString *parameterName;
@property int cablerEdge;
@property double edgeOffset;
@property (weak) id <PatchCableEndpointDelegate> delegate;
@property (weak) id connectedTo;

@property (readonly) NSSize size;
- (NSPoint)origin;
- (PatchCableEndpoint*)target;

- (id)initWithType:(int)endpointType 
           andName:(NSString*)name
            onEdge:(int)edge
        withOffset:(double)offset
         withColor:(NSColor*)color
      parentBounds:(NSRect)bounds
                  ;

@end
