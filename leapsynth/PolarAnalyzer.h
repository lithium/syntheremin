//
//  PolarAnalyzer.h
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "synth.h"

#define kMaxRipples 3

#define kMaxSecondsBetweenRipples 0.3
#define kMinSecondsBetweenRipples 0.50
#define kRandSecondsBetweenShed 3


#define kZoomRatio 2
#define kNumSamplesPerRipple 2500


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


@interface Ripple : NSObject{
    @public
    NSBezierPath *path;
    CFAbsoluteTime created;
}
@end

@interface PolarAnalyzer : NSView <AnalyzerDelegate>
{
    NSColor *waveColor;
    
    NSMutableData *sampleBuffer;
    
    Waveform *firstRipple;
    NSMutableArray *ripples;
    
    CFAbsoluteTime lastRippleTime;
    BOOL silent;

}

- (void)receiveSamples:(id)sender :(short *)samples :(int)numSamples;
- (void)shedRipple;
@end
