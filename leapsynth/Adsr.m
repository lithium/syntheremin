//
//  Adsr.m
//  leapsynth
//
//  Created by Wiggins on 8/1/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Adsr.h"
#import "Defines.h"

@implementation Adsr

- (void)noteOn
{
    self->noteOn = true;
}
- (void)noteOff
{
    self->noteOff = true;
}

- (void)setAttackTimeInMs:(int) ms
{
    attackMS = MAX(MIN(ms, kMsMax), kMsMin);
    
    double temp = (0.001*attackMS) / (1.0/kSampleRate);
    attackCount = (int)temp;
    attackSlope = 1.0/temp;
}

- (void)setDecayTimeInMs:(int) ms
{
    decayMS = MAX(MIN(ms, kMsMax), kMsMin);
    double temp = (0.001*decayMS)/(1.0/kSampleRate);
    decayCount = (int)temp;
    decaySlope = (1.0 - sustainLevel) / temp;
}

- (void)setSustainLevel:(double)newLevel
{
    sustainLevel = MAX(MIN(newLevel, kSustainMax), kSustainMin);
    [self setDecayTimeInMs:decayMS];
    [self setReleaseTimeInMs:releaseMS];
}

- (void)setReleaseTimeInMs:(int) ms
{
    releaseMS = MAX(MIN(ms, kMsMax), kMsMin);
    double temp = (0.001*releaseMS)/(1.0/kSampleRate);
    releaseCount = (int)temp;
    releaseSlope = sustainLevel / temp;
}

- (double)getSample
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
- (void)updatePropertyList:(NSMutableDictionary*)props
{
    [super updatePropertyList:props];
    [props setObject:[NSNumber numberWithInt:attackMS] forKey:@"attackTimeInMs"];
    [props setObject:[NSNumber numberWithInt:decayMS] forKey:@"decayTimeInMs"];
    [props setObject:[NSNumber numberWithDouble:sustainLevel] forKey:@"sustainLevel"];
    [props setObject:[NSNumber numberWithInt:releaseMS] forKey:@"releaseTimeInMs"];

}

@end
