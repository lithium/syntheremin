//
//  Adsr.m
//  leapsynth
//
//  Created by Wiggins on 8/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Adsr.h"

@implementation Adsr


- (void)setAttackTimeInMs:(int) ms
{
    ms = MAX(MIN(ms, kMsMax), kMsMin);
    
    double temp = (0.001*ms)/sampleTime;
    attackCount = (int)temp;
    attackSlope = 1.0/temp;
}

- (void)setDecayTimeInMs:(int) ms
{
    decayMS = MAX(MIN(ms, kMsMax), kMsMin);
    double temp = (0.001*decayMS)/sampleTime;
    decayCount = (int)temp;
    decaySlope = (1.0 - sustainLevel) / temp;
}

- (void)setSustainLevel:(double) level
{
    sustainLevel = MAX(MIN(level, kSustainMax), kSustainMin);
    [self setDecayTimeInMs:decayMS];
    [self setReleaseTimeInMs:releaseMS];
}

- (void)setReleaseTimeInMs:(int) ms
{
    releaseMS = MAX(MIN(ms, kMsMax), kMsMin);
    double temp = (0.001*releaseMS)/sampleTime;
    releaseCount = (int)temp;
    releaseSlope = sustainLevel / temp;
}

- (double)getValue
{
    double value = 0.0;
    
    switch (state) {
        case kStateIdle:
            noteOff = false;
            if (noteOn) {
                noteOn = false;
                count = 0;
                state = kStateAttack;
            }
            break;
        case kStateAttack:
            if (noteOn) {
                state = kStateIdle;
                break;
            }
            value = count*attackSlope;
            if (count++ > attackCount) {
                count = 0;
                state = kStateDecay;
            } 
            break;
        case kStateDecay:
            if (noteOn) {
                state = kStateIdle;
                break;
            }
            value = 1.0 - (count*decaySlope);
            if (count++ >= decayCount) {
                state = kStateSustain;
            }
            break;
        case kStateSustain:
            if (noteOn) {
                state = kStateIdle;
                break;
            }
            value = sustainLevel;
            if (noteOff) {
                noteOff = false;
                count = 0;
                state = kStateRelease;
            }
            break;
        case kStateRelease:
            if (noteOn) {
                state = kStateIdle;
                break;
            }
            value = MAX(0, sustainLevel - (count*releaseSlope));
            if (count++ >= releaseCount) {
                state = kStateIdle;
            }
            break;
    }
    return value;
}

@end
