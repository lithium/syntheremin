//
//  PolarAnalyzer.h
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "synth.h"

#define kMaxRipples 10
#define kMinSecondsBetweenRipples 0.050

@interface Waveform : NSObject
{
    @public
    NSMutableData *buffer;
    int samplesInBuffer;
    double baseRadius;
    double minRadius;
    double maxRadius;
    NSRect bounds;
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
    
    NSMutableArray *ripples;
    CFAbsoluteTime lastRippleTime;
}

- (void)receiveSamples :(short *)samples :(int)numSamples;
- (void)shedRipple;
@end
