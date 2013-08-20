//
//  SynthAnalyzer.h
//  leapsynth
//
//  Created by Wiggins on 8/13/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct Point3 {
    CGFloat x,y,z;
} Point3;

#define kHandRadiusMin 2
#define kHandRadiusMax 75

@interface SynthAnalyzer : NSView
{
    int samplesInBuffer;
    NSMutableData *buffer;
    NSColor *waveColor,*leftDotColor,*rightDotColor,*majorAxisColor,*minorAxisColor;
    
    Point3 leftHand,rightHand;
}

- (void) receiveSamples :(short *)samples :(int)numSamples;

- (void) setLeftHand:(CGFloat)x :(CGFloat)y :(CGFloat)z;
- (void) setRightHand:(CGFloat)x :(CGFloat)y :(CGFloat)z;

@end
