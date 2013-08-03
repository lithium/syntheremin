//
//  AppDelegate.h
//  leapsynth
//
//  Created by Wiggins on 7/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AudioToolbox/AudioQueue.h"
#import "Defines.h"
#import "Synth.h"
#import "DownUpButton.h"


@interface AppDelegate : NSObject <NSApplicationDelegate, DownUpButtonDelegate> {
    Synth *synth;
    AudioQueueRef mAudioQueue;
    AudioQueueBufferRef mQueueBuffers[kNumBuffers];
}

@property (assign) IBOutlet NSWindow *window;


//OSC1
- (IBAction)setVcoShape:(id)sender;
- (IBAction)setVcoRange:(id)sender;
- (IBAction)setVcoDetune:(id)sender;
@property (weak) IBOutlet NSSlider *osc1_shape;
@property (weak) IBOutlet NSSlider *osc1_range;
@property (weak) IBOutlet NSSlider *osc1_detune;


//OSC2
- (IBAction)setLfoShape:(id)sender;
- (IBAction)setLfoFrequency:(id)sender;
- (IBAction)setFmDepth:(id)sender;
- (IBAction)setAmDepth:(id)sender;
@property (weak) IBOutlet NSSlider *osc2_shape;
@property (weak) IBOutlet NSSlider *osc2_freq;
@property (weak) IBOutlet NSSlider *osc2_fm;
@property (weak) IBOutlet NSSlider *osc2_am;

@property (weak) IBOutlet DownUpButton *keyboard_1;
@property (weak) IBOutlet DownUpButton *keyboard_2;
@property (weak) IBOutlet DownUpButton *keyboard_3;
@property (weak) IBOutlet DownUpButton *keyboard_4;
@property (weak) IBOutlet DownUpButton *keyboard_5;
@property (weak) IBOutlet NSSlider *cv_1;
@property (weak) IBOutlet NSSlider *cv_2;
@property (weak) IBOutlet NSSlider *cv_3;
@property (weak) IBOutlet NSSlider *cv_4;
@property (weak) IBOutlet NSSlider *cv_5;

- (void)mouseDown:(NSEvent *)evt :(int)tag;
- (void)mouseUp:(NSEvent *)evt :(int)tag;


//VCA
@property (weak) IBOutlet NSSlider *vca_attack;
@property (weak) IBOutlet NSSlider *vca_decay;
@property (weak) IBOutlet NSSlider *vca_sustain;
@property (weak) IBOutlet NSSlider *vca_release;
- (IBAction)setVcaAttack:(id)sender;
- (IBAction)setVcaDecay:(id)sender;
- (IBAction)setVcaSustain:(id)sender;
- (IBAction)setVcaRelease:(id)sender;

@end
