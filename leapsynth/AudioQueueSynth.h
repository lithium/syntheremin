//
//  AudioQueueSynth.h
//  leapsynth
//
//  Created by Wiggins on 10/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Synth.h"
#import "AudioToolbox/AudioQueue.h"


@interface AudioQueueSynth : Synth
{
    AudioQueueRef queueOsc1,queueOsc2;
    AudioQueueBufferRef buffersOsc1[kNumBuffers], buffersOsc2[kNumBuffers];
    
}
    
- (void)start;
- (void)stop;
- (void)noteOn;
- (void)noteOff;
- (void)primeBuffers;

@end

