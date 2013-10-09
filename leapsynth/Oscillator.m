//
//  Vco.m
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Oscillator.h"

@implementation Oscillator

@synthesize waveShape;


- (id) init
{
    [self setFrequency:0];
    return self;
}

- (void) setFrequency :(double)frequency
{
    if (frequency == 0) {
        samplesPerPeriod = 0;
        return;
    }
    samplesPerPeriod = (long)(kSampleRate / frequency);
}

- (double) getSample
{
    if (samplesPerPeriod == 0)
        return 0;
    
    double value;
    double x = sampleStep / (double)samplesPerPeriod;
    switch (waveShape) {
            
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
            
        case kWaveTriangle:
            value = fabs( 2.0 * (x - floor(x + 0.5))) - 0.5;   // Thanks to Tom Hall! @t-hall
            break;
            
        default:
        case kWaveSine:
            value = sin(2.0 * M_PI * x);
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