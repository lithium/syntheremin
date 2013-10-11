//
//  Vca.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Vca.h"

@implementation Vca
@synthesize masterVolume;

- (id)init
{
    [self setAttackTimeInMs:0];
    [self setDecayTimeInMs:0];
    [self setReleaseTimeInMs:0];
    [self setSustainLevel:1.0];
    
    masterVolume = 1.0;
    return self;
}

- (double)getValue
{
    double value = masterVolume;
    value *= [super getValue];
    return value;
}

- (int) modifySamples :(short *)samples :(int)numSamples
{
    int i;
    for (i=0; i < numSamples; i++) {
        double value = [self getValue];
        samples[i] *= value;
    }
    return numSamples;
}

@end
