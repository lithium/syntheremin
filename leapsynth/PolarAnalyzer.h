//
//  PolarAnalyzer.h
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "synth.h"

@interface PolarAnalyzer : NSView <AnalyzerDelegate>
{
    int samplesInBuffer;
    NSMutableData *buffer;
    NSColor *waveColor;
}

- (void) receiveSamples :(short *)samples :(int)numSamples;

@end
