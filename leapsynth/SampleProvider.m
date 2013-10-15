//
//  SampleProvider.m
//  leapsynth
//
//  Created by Wiggins on 10/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SampleProvider.h"

@implementation SampleProvider
@synthesize level;
@synthesize modulator;

- (id) init
{
    if (self) {
        level = 1.0;
    }    
    return self;
}

- (double) getSample
{
    return 0;
}


- (double) getModulationSample
{
    if (modulator && [modulator respondsToSelector:@selector(getSample)]) {
        return (double)[modulator getSample];
    }
    return 1.0;
}

- (int) getSamples :(short *)samples :(int)numSamples
{
    for (int i=0; i < numSamples; i++) {
        double ds = [self getSample]*level * (double)SHRT_MAX; 
        short ss = (short)round(ds);
        samples[i] = ss;
    }
    return numSamples;
}

- (int) mixSamples :(short *)samples :(int)numSamples
{
    // average new samples with existing ones to mix
    for (int i=0; i < numSamples; i++) {
        double ds = [self getSample]*level * (double)SHRT_MAX;
        short ss = (short)round(ds);
        samples[i] = (samples[i] + ss) / 2;
    }
    return numSamples;
}


@end
