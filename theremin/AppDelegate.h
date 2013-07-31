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
    kBufferSize = 2000,
};
#define kPhaseIncrement (2*M_PI*450/kSampleRate)

typedef struct {
    float phase;
    float frequency;
    float step;
} WaveData;


@interface AppDelegate : NSObject <NSApplicationDelegate> {
    WaveData mWaveform;
    AudioQueueRef mAudioQueue;
    AudioQueueBufferRef mQueueBuffers[kNumBuffers];
}

@property (assign) IBOutlet NSWindow *window;
- (IBAction)takeIntValueForFrequencyFrom:(id)sender;
@property (weak) IBOutlet NSSlider *osc2_freq;



@end
