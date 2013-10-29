//
//  PolarAnalyzer.h
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "synth.h"

#define kMaxRipples 5
#define kMinSecondsBetweenRipples 0.250
#define kMaxSecondsBetweenRipples 2
#define kRandSecondsBetweenShed 3


#define kZoomRatio 1.5  // desample ratio
#define kNumSamplesPerRipple 2000


@interface Waveform : NSObject
{
    @public
    NSMutableData *buffer;
    int samplesInBuffer;
    double baseRadius;
    double minRadius;
    double maxRadius;
    NSRect bounds;
    double frequency;
}
@property NSRect bounds;
@property double minRadius;

- (id)initWithBounds:(NSRect)bounds;
- (id)copyWithZone:(NSZone *)zone;
- (NSBezierPath*)bezierPath;
@end


@interface PolarAnalyzer : NSView <AnalyzerDelegate>
{
    NSColor *waveColor;
    
    NSMutableData *sampleBuffer;
    
    NSMutableArray *ripples;
    CFAbsoluteTime lastRippleTime;
}

- (void)receiveSamples:(id)sender :(short *)samples :(int)numSamples;
- (void)shedRipple;
@end
