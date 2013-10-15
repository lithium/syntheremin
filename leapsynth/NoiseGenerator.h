//
//  NoiseGenerator.h
//  leapsynth
//
//  Created by Wiggins on 10/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleProvider.h"

enum  {
    kNoiseNone=0,
    kNoiseWhite=1,
    kNoisePink=2,
};

#define kNumWhiteValues 5
#define kPinkKeyMax 0x1F

@interface NoiseGenerator : SampleProvider
{
    int noiseType;
    
    // pink noise state
    int pinkKey;
    short whiteValues[kNumWhiteValues];
}
@property int noiseType;

- (id) init;

- (double)getSample;
- (double)getPinkSample;
- (double)getWhiteSample;

@end
