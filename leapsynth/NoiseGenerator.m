//
//  NoiseGenerator.m
//  leapsynth
//
//  Created by Wiggins on 10/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "NoiseGenerator.h"

@implementation NoiseGenerator
@synthesize noiseType;


- (id) init
{
    if (self) {
        self = [super init];
        [self setNoiseType:kNoiseNone];
    }    
    return self;
}


- (double)getSample
{
    switch (noiseType) {
        case kNoiseWhite:
            return [self getWhiteSample];
        case kNoisePink:
            return [self getPinkSample];
    }
    return 0;
}

- (double)getWhiteSample
{
    return arc4random_uniform(SHRT_MAX) / (double)SHRT_MAX;
}

- (double)getPinkSample
{
    return 0;
}


@end
