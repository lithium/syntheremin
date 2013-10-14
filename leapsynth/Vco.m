//
//  Vco.m
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Vco.h"

@implementation Vco



- (id)init
{
    if (self) {
        self = [super init];
        
        rangeMultiplier = 1.0;
        detuneMultiplier = 1.0;
    }
    return self;
}


- (void)setRange :(int)octave
{
    switch (octave) {
        case -2:
            rangeMultiplier = 0.25;
            break;
        case -1:
            rangeMultiplier = 0.5;
            break;
        default:
        case 0:
            rangeMultiplier = 1.0;
            break;
        case 1:
            rangeMultiplier = 2.0;
            break;
        case 2:
            rangeMultiplier = 4.0;
            break;
    }
}

- (void)setDetuneInCents :(int)cents
{
    if (cents == 0)
        detuneMultiplier = 1.0;
    else if (cents < kCentsDetuneMin)
        detuneMultiplier = kCentsDetuneMin;
    else if (cents > kCentsDetuneMax)
        detuneMultiplier = kCentsDetuneMax;
        
    detuneMultiplier = pow(2.0, (double)((double)cents / kCentsPerOctave));
}


- (double)getSample
{
    double orig = [self getFrequencyInHz];
    double freq = orig;
    if ([self->modulator respondsToSelector:@selector(getSample)]) {
        freq *= pow(2.0, [self->modulator getSample]);
    }
    
    freq *= rangeMultiplier;
    freq /= detuneMultiplier;
    
    [self setFrequencyInHz:freq];
    double sample = [super getSample];
    [self setFrequencyInHz:orig];
    
    return sample;
}
@end
