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
    int samplesInBuffer;
    NSMutableData *buffer;
}

- (void) receiveSamples :(short *)samples :(int)numSamples;

@end
