//
//  LeapCursorOverlay.h
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct Point3 {
    CGFloat x,y,z;
} Point3;

#define kHandRadiusMin 2
#define kHandRadiusMax 75

@interface LeapCursorOverlay : NSView
{
    NSColor *leftDotColor,*rightDotColor;
    Point3 leftHand,rightHand;
}

- (void) setLeftHand:(CGFloat)x :(CGFloat)y :(CGFloat)z;
- (void) setRightHand:(CGFloat)x :(CGFloat)y :(CGFloat)z;

@end
