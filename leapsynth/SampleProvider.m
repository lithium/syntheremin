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


- (int) getSamples :(short *)samples :(int)numSamples
{
    int index=0;
    for (int i=0; i < numSamples; i++) {
        double ds = [self getSample]*level * (double)SHRT_MAX; 
        short ss = (short)round(ds);
        samples[index++] = ss;
    }
    return numSamples;
}

- (int) mixSamples :(short *)samples :(int)numSamples
{
    int index=0;
    for (int i=0; i < numSamples; i++) {
        double ds = [self getSample]*level * (double)SHRT_MAX;
        short ss = (short)round(ds);
        samples[index] = (samples[index] + ss) / 2;
        index+=1;
    }
    return numSamples;
}


@end
