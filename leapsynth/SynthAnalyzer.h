//
//  SynthAnalyzer.h
//  leapsynth
//
//  Created by Wiggins on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SynthAnalyzer : NSView
{
    short buffer[2048];
    int samplesInBuffer;
}

- (void) receiveSamples :(short *)samples :(int)numSamples;

@end
