//
//  SynthAnalyzer.h
//  leapsynth
//
//  Created by Wiggins on 8/13/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LinearAnalyzer : NSView
{
    int samplesInBuffer;
    NSMutableData *buffer;
    NSColor *waveColor,*majorAxisColor,*minorAxisColor;
    
}

- (void) receiveSamples :(short *)samples :(int)numSamples;


@end
