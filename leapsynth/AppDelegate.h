//
//  AppDelegate.h
//  leapsynth
//
//  Created by Wiggins on 7/29/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AudioToolbox/AudioQueue.h"
#import "Defines.h"
#import "Synth.h"
#import "DownUpButton.h"
#import "LeapSyntheremin.h"
#import "AudioQueueSynth.h"

enum {
    kParameterNone=0,
    kParameterPitch=1,
    kParameterVolume=2,
    kParameterFrequency=3,
    kParameterResonance=4,
    kParameterLfoSpeed=5,
    kParameterLfoAmount=6,
    kParameterNote=7,
    kParameterVcaEnvelope=8,
    kParameterFilterEnable=9,
    kParameterFilterEnvelope=10,
    kParameterVcoWaveshape=11,
    kParameterLfoWaveshape=12,
    kParameterLfoModulation=13,
    kParameterRangeUp=14,
    kParameterRangeDown=15,
};
#define kParameterTypeNamesArray @"None",@"Pitch",@"Volume",@"Cutoff Frequency",@"Resonance",@"LFO Speed",@"LFO Amount",@"Toggle Note On/Off",@"Toggle Amplifier Envelope",@"Toggle Filter",@"Toggle Filter Envelope",@"Change Oscillator Waveshape",@"Change LFO Waveshape",@"Change LFO Modulation",@"Range Up",@"Range Down", nil

enum {
    kInputLeftHandX,
    kInputLeftHandY,
    kInputLeftHandZ,
    kInputLeftHandTap,
    kInputRightHandX,
    kInputRightHandY,
    kInputRightHandZ,
    kInputRightHandTap,
    kInputEnumSize,
};
#define kInputTypeNamesArray @"Left Hand X",@"Left Hand Y",@"Left Hand Z",@"Left Hand Tap",@"Right Hand X",@"Right Hand Y",@"Right Hand Z",@"Right Hand Tap",nil

#define kFrequencyMin 20
#define kFrequencyMax 2093
#define kLfoFrequencyMin 1
#define kLfoFrequencyMax 20
#define kNoteThreshold 0.90


@interface AppDelegate : NSObject <NSApplicationDelegate, DownUpButtonDelegate, LeapSynthereminDelegate> {
    AudioQueueSynth *synth;
//    AudioQueueRef mAudioQueue;
//    AudioQueueBufferRef mQueueBuffers[kNumBuffers];
    
    LeapSyntheremin *mSyntheremin;
        
    NSArray *kParameterTypeArray;
    NSArray *kInputTypeArray;
    int inputParams[kInputEnumSize];
    
    bool paramNoteOn;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSDrawer *drawer;


//OSC1
- (IBAction)setVcoShape:(id)sender;
- (IBAction)setVcoRange:(id)sender;
@property (weak) IBOutlet NSSlider *osc1_shape;
@property (weak) IBOutlet NSSlider *osc1_range;
@property (weak) IBOutlet NSSlider *osc1_freq;
- (IBAction)setVcoFrequency:(id)sender;

//OSC2
- (IBAction)setVco2Shape:(id)sender;
- (IBAction)setVco2Range:(id)sender;
- (IBAction)setVco2Detune:(id)sender;
@property (weak) IBOutlet NSSlider *osc2_shape;
@property (weak) IBOutlet NSSlider *osc2_range;
@property (weak) IBOutlet NSSlider *osc2_detune;



//LFO
- (IBAction)setLfoAmount:(id)sender;
- (IBAction)setLfoType:(id)sender;
- (IBAction)setLfoShape:(id)sender;
- (IBAction)setLfoFrequency:(id)sender;
@property (weak) IBOutlet NSSlider *lfo_shape;
@property (weak) IBOutlet NSSlider *lfo_freq;
@property (weak) IBOutlet NSSlider *lfo_amount;
@property (weak) IBOutlet NSSlider *lfo_type;

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
//@property (weak) IBOutlet NSButton *vca_note;
//- (IBAction)toggleVcaNote:(id)sender;

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

- (IBAction)toggleOsc2:(id)sender;
@property (weak) IBOutlet NSButton *osc2_enable;

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
@property (weak) IBOutlet NSPopUpButton *lefthand_tap_popup;
@property (weak) IBOutlet NSPopUpButton *righthand_tap_popup;

@property (weak) IBOutlet SynthAnalyzer *synthAnalyzer;
@property (weak) IBOutlet NSBox *lefthand_box;
@property (weak) IBOutlet NSBox *righthand_box;
@property (weak) IBOutlet NSTextField *noleap_label;

@property (weak) IBOutlet NSPredicateEditor *patch_predicateeditor;
- (IBAction)changePredicate:(id)sender;
@end
