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

@interface PatchCableEndpoint : NSView
{
    int endpointType;
    
    int cablerEdge;
    double edgeOffset;
    
    NSString *parameterName;
    
   
    @private
    NSImage *image;
}

@property int endpointType;
@property int cablerEdge;
@property double edgeOffset;

@property NSString *parameterName;


@end
