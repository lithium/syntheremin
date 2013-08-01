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
#import "Vco.h"
#import "DownUpButton.h"


@interface AppDelegate : NSObject <NSApplicationDelegate, DownUpButtonDelegate> {
    Vco *vco;
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

- (IBAction)clickKey:(id)sender;
@property (weak) IBOutlet DownUpButton *keyboard_1;
@property (weak) IBOutlet DownUpButton *keyboard_2;

- (void)mouseDown:(NSEvent *)evt :(int)tag;
- (void)mouseUp:(NSEvent *)evt :(int)tag;

@end
