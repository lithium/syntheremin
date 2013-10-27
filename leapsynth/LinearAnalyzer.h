//
//  SynthAnalyzer.h
//  leapsynth
//
//  Created by Wiggins on 8/13/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Synth.h"

@interface LinearAnalyzer : NSView <AnalyzerDelegate>
{
    int samplesInBuffer;
    NSMutableData *buffer;
    NSColor *waveColor,*majorAxisColor,*minorAxisColor;

    
}

@property BOOL drawAxis;

- (void) receiveSamples:(id)sender :(short *)samples :(int)numSamples;
- (void)shedRipple;

@end
