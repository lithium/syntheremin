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
        
        //prep pink noise state
        pinkKey = 0;
        for (int i=0; i < kNumWhiteValues; i++) {
            whiteValues[i] = arc4random_uniform(SHRT_MAX);
        }
    }    
    return self;
}


- (double)getSample
{
    switch (noiseType) {
        case kNoiseWhite:
            return [self getWhiteSample]*level;
        case kNoisePink:
            return [self getPinkSample]*level;
    }
    return 0;
}

- (double)getWhiteSample
{
    return arc4random_uniform(SHRT_MAX) / (double)SHRT_MAX;
}

- (double)getPinkSample
{
    /* Voss algorithm http://www.firstpr.com.au/dsp/pink-noise/#Voss */
    int lastKey = pinkKey;
    unsigned int sum;
    
    pinkKey++;
    if (pinkKey > kPinkKeyMax) 
        pinkKey = 0;
    
    int diff = lastKey ^ pinkKey;
    sum = 0;
    for (int i=0; i < kNumWhiteValues; i++) {
        if (diff & (1 << i)) {
            whiteValues[i] = arc4random_uniform(SHRT_MAX / kNumWhiteValues);
        }
        sum += whiteValues[i];
    }
    return sum / (double)SHRT_MAX;
    
}
- (void)updatePropertyList:(NSMutableDictionary*)props
{
    [super updatePropertyList:props];
    [props setObject:[NSNumber numberWithInt:noiseType] forKey:@"noiseType"];
}


@end
