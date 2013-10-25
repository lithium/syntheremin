//
//  LeapCursorOverlay.h
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct Point3 {
    double x,y,z;
} Point3;

#define kHandRadiusMin 5
#define kHandRadiusMax 40

@interface LeapCursorOverlay : NSView
{
    NSColor *leftDotColor,*rightDotColor;
    Point3 leftHand,rightHand;
    NSRect cursorFrame;
}

- (void) setLeftHand:(CGFloat)x :(CGFloat)y :(CGFloat)z;
- (void) setRightHand:(CGFloat)x :(CGFloat)y :(CGFloat)z;

@end
