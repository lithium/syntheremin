//
//  SynthAnalyzer.h
//  leapsynth
//
//  Created by Wiggins on 8/13/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Synth.h"


#define kLinearAnalyzerZoomRatio 2
#define kLinearAnalyzerSamplesPerRipple 1500

@interface LinearAnalyzer : NSView <AnalyzerDelegate>
{
    NSMutableData *buffer;
    NSBezierPath *wavePath;

    NSColor *waveColor,*majorAxisColor,*minorAxisColor;
    
    NSBezierPath *minorAxisPath;
    NSBezierPath *majorAxisPath;
}

@property BOOL drawAxis;

- (void) receiveSamples:(id)sender :(short *)samples :(int)numSamples;
- (void)shedRipple;

@end
