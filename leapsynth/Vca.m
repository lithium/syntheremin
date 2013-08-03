//
//  Vca.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Vca.h"

@implementation Vca

- (id)init
{
    [self setAttackTimeInMs:1];
    [self setDecayTimeInMs:1000];
    [self setSustainLevel:0.5];
    [self setReleaseTimeInMs:2000];
    return self;
}

- (int) modifySamples :(short *)samples :(int)numSamples
{
    int index=0;
    int i;
    for (i=0; i < numSamples; i++) {
        samples[i] *= [self getValue];
    }
    return numSamples;
}

@end
