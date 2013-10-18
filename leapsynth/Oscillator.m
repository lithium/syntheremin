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


- (void) setFrequencyInHz :(double)frequency
{
    currentFrequency = frequency;
    if (frequency == 0) {
        samplesPerPeriod = 0;
        return;
    }
    samplesPerPeriod = (long)(kSampleRate / frequency);
}
- (double) getFrequencyInHz
{
    return currentFrequency;
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
    return value*[self level];
}
- (void)updatePropertyList:(NSMutableDictionary*)props
{
    [super updatePropertyList:props];
    [props setObject:[NSNumber numberWithInt:waveShape] forKey:@"waveShape"];
    [props setObject:[NSNumber numberWithDouble:currentFrequency] forKey:@"frequencyInHz"];
}

@end