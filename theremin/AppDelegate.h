//
//  AppDelegate.h
//  theremin
//
//  Created by Wiggins on 7/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AudioToolbox/AudioQueue.h"


enum {
    kSampleRate = 44100,
    kNumBuffers = 3,
};
#define kPhaseIncrement (2*M_PI*450/kSampleRate)

typedef struct {
    double phase;
    int count;
    double freq;
} PhaseData;


@interface AppDelegate : NSObject <NSApplicationDelegate> {
    PhaseData mPhase;
    AudioQueueRef mAudioQueue;
    AudioQueueBufferRef mQueueBuffers[kNumBuffers];
}

@property (assign) IBOutlet NSWindow *window;

@end
