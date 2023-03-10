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

#define kMaxNumberOfLoops 10

struct LooperCallbackState {
    void *self;
    int loopIndex;
    AudioQueueRef queue;
    AudioQueueBufferRef buffers[kNumBuffers];
};

@interface Looper : NSObject
{
    AudioStreamBasicDescription audioFormat;
    NSMutableArray *loops;
    BOOL isRecording;
    BOOL isPlaying;
    
    int longestLoopSize;
    Loop *delegateLoop;
    
    struct LooperCallbackState states[kMaxNumberOfLoops];
}

@property int longestLoopSize;
@property (weak) id <LoopDelegate> delegate;

- (id)init;
- (void)dealloc;

- (BOOL)recordNewLoop;
- (void)stopRecording;
- (void)playAll;
- (void)stopPlayback;
- (void)clearAllLoops;
- (void)undoLastLoop;

- (void)recordSamples:(short*)samples :(int)num_samples;
- (void)fillPlaybackBuffer:(int)loopIndex :(short*)samples :(int)num_samples;


@end
