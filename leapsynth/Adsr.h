//
//  Adsr.h
//  leapsynth
//
//  Created by Wiggins on 8/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
enum {
    kStateIdle, kStateAttack, kStateDecay, kStateSustain, kStateRelease
};

#define kMsMin 1
#define kMsMax 5000
#define kSustainMin 0.0
#define kSustainMax 1.0


@interface Adsr : NSObject {
    bool noteOn;
    bool noteOff;
    int count;
    int state;
    
    
    int attackCount;
    double attackSlope;
    
    int decayMS;
    int decayCount;
    double decaySlope;
    
    double sustainLevel;
    
    int releaseMS;
    int releaseCount;
    double releaseSlope;
    
}

- (void)setAttackTimeInMs:(int) ms;
- (void)setDecayTimeInMs:(int) ms;
- (void)setSustainLevel:(double) level;
- (void)setReleaseTimeInMs:(int) ms;

- (double)getValue;

- (void)noteOn;
- (void)noteOff;

@end
