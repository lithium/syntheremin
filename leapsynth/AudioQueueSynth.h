//
//  AudioQueueSynth.h
//  leapsynth
//
//  Created by Wiggins on 10/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AudioToolbox/AudioQueue.h"
#import "Looper.h"
#import "Synth.h"

struct CallbackArg {
    void *self;
};

@interface AudioQueueSynth : Synth
{
    AudioQueueRef queueOsc;
    AudioQueueBufferRef buffersOsc[kNumBuffers];
    struct CallbackArg callbackArgs;

    Looper *looper;
}

@property Looper *looper;


- (void)start;
- (void)stop;
- (void)noteOn;

@end

