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
#import "LeapSyntheremin.h"

enum {
    kParameterNone=0,
    kParameterPitch=1,
    kParameterVolume=2,
    kParameterFrequency=3,
    kParameterResonance=4,
    kParameterLfoSpeed=5,
    kParameterLfoAmount=6,
    kParameterNote=7,
};
#define kFrequencyMin 20
#define kFrequencyMax 2093
#define kLfoFrequencyMin 1
#define kLfoFrequencyMax 20
#define kNoteThreshold 0.90

@interface AppDelegate : NSObject <NSApplicationDelegate, DownUpButtonDelegate, LeapSynthereminDelegate> {
    Synth *synth;
    AudioQueueRef mAudioQueue;
    AudioQueueBufferRef mQueueBuffers[kNumBuffers];
    
    LeapSyntheremin *mSyntheremin;
    int leftParamX, leftParamY, leftParamZ;
    int rightParamX, rightParamY, rightParamZ;
    bool paramNoteOn;
}

@property (assign) IBOutlet NSWindow *window;


//OSC1
- (IBAction)setVcoShape:(id)sender;
- (IBAction)setVcoRange:(id)sender;
- (IBAction)setVcoDetune:(id)sender;
@property (weak) IBOutlet NSSlider *osc1_shape;
@property (weak) IBOutlet NSSlider *osc1_range;
@property (weak) IBOutlet NSSlider *osc1_detune;
@property (weak) IBOutlet NSSlider *osc1_freq;
- (IBAction)setVcoFrequency:(id)sender;


//OSC2
- (IBAction)setLfoAmount:(id)sender;
- (IBAction)setLfoType:(id)sender;
- (IBAction)setLfoShape:(id)sender;
- (IBAction)setLfoFrequency:(id)sender;
@property (weak) IBOutlet NSSlider *osc2_shape;
@property (weak) IBOutlet NSSlider *osc2_freq;
@property (weak) IBOutlet NSSlider *osc2_amount;
@property (weak) IBOutlet NSSlider *osc2_type;

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
@property (weak) IBOutlet NSSlider *vca_master;
- (IBAction)setVcaMaster:(id)sender;
@property (weak) IBOutlet NSButton *vca_enable;
- (IBAction)toggleVcaEnvelope:(id)sender;
@property (weak) IBOutlet NSButton *vca_note;
- (IBAction)toggleVcaNote:(id)sender;

//VCF
@property (weak) IBOutlet NSSlider *vcf_attack;
@property (weak) IBOutlet NSSlider *vcf_decay;
@property (weak) IBOutlet NSSlider *vcf_sustain;
@property (weak) IBOutlet NSSlider *vcf_release;
@property (weak) IBOutlet NSSlider *vcf_cutoff;
@property (weak) IBOutlet NSSlider *vcf_resonance;
@property (weak) IBOutlet NSSlider *vcf_depth;
- (IBAction)setVcfAttack:(id)sender;
- (IBAction)setVcfDecay:(id)sender;
- (IBAction)setVcfSustain:(id)sender;
- (IBAction)setVcfRelease:(id)sender;
- (IBAction)setVcfCutoff:(id)sender;
- (IBAction)setVcfResonance:(id)sender;
- (IBAction)setVcfDepth:(id)sender;
- (IBAction)toggleFilterEnvelope:(id)sender;
@property (weak) IBOutlet NSButton *vcf_envelope_enable;
@property (weak) IBOutlet NSButton *vcf_enable;
- (IBAction)toggleVcfEnable:(id)sender;


@property (weak) IBOutlet NSLevelIndicator *lefthand_x;
@property (weak) IBOutlet NSLevelIndicator *lefthand_y;
@property (weak) IBOutlet NSLevelIndicator *lefthand_z;
@property (weak) IBOutlet NSLevelIndicator *righthand_x;
@property (weak) IBOutlet NSLevelIndicator *righthand_y;
@property (weak) IBOutlet NSLevelIndicator *righthand_z;
@property (weak) IBOutlet NSPopUpButton *lefthand_x_popup;
@property (weak) IBOutlet NSPopUpButton *lefthand_y_popup;
@property (weak) IBOutlet NSPopUpButton *lefthand_z_popup;
@property (weak) IBOutlet NSPopUpButton *righthand_x_popup;
@property (weak) IBOutlet NSPopUpButton *righthand_y_popup;
@property (weak) IBOutlet NSPopUpButton *righthand_z_popup;
- (IBAction)setParameter:(id)sender;

@property (weak) IBOutlet SynthAnalyzer *synthAnalyzer;

@end
