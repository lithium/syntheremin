//
//  Looper.h
//  leapsynth
//
//  Created by Wiggins on 10/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Defines.h"
#import "Loop.h"


struct LooperCallbackState {
    void *self;
};

@interface Looper : NSObject
{
    AudioStreamBasicDescription audioFormat;
    NSMutableArray *loops;
    BOOL isRecording;
    BOOL isPlaying;
    
    struct LooperCallbackState callbackState;
    AudioQueueRef recordingQueue;
    AudioQueueRef playbackQueue;
    AudioQueueBufferRef playbackBuffers[kNumBuffers];
}

- (id)init;
- (void)dealloc;

- (void)recordNewLoop;
- (void)stopRecording;
- (void)playAll;
- (void)stopPlayback;


- (void)fillPlaybackBuffer:(short*)samples :(int)num_samples;

@end
