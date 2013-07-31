//
//  Vco.m
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Vco.h"

@implementation Vco

@synthesize waveShape;

- (void) setFrequency :(int)freq
{
    samplesPerPeriod = (long)(kSampleRate / freq);
}

- (double) getSample
{
    double value;
    double x = sampleStep / (double)samplesPerPeriod;
    switch (waveShape) {
        default:
        case kWaveSine:
            value = sin(2.0 * M_PI * x);
            break;
            
        case kWaveSquare:
            if (sampleStep < (samplesPerPeriod/2)) {
                value = 1.0;
            } else {
                value = -1.0;
            }
            break;
        
        case kWaveSaw:
            value = 2.0 * (x - floor(x + 0.5));
            break;
            
    }
    sampleStep = (sampleStep+1) % samplesPerPeriod;
    return value;
}

- (int) getSamples :(short *)samples :(int)numSamples
{
    int index=0;
    for (int i=0; i < numSamples; i++) {
        double ds = [self getSample] * 32767.0;
        short ss = (short)round(ds);
        samples[index++] = ss;
    }
    return numSamples;
}


@end