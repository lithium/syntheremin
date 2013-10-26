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
#import "LeapSyntheremin.h"
#import "AudioQueueSynth.h"
#import "Looper.h"
#import "MidiParser.h"
#import "LinearAnalyzer.h"
#import "PatchCabler.h"
#import "PolarAnalyzer.h"

#import "CSKnob.h"
#import "CSFader.h"
#import "CSToggleButton.h"
#import "CSRadioButtonSet.h"
#import "LeapCursorOverlay.h"
#import "LeapModulator.h"

enum {
    kTuningNone=0,
    kTuningMajor=1,
    kTuningBlues=2,
    kTuningHarmonicMinor=3,
};

@interface AppDelegate : NSResponder  <NSApplicationDelegate, 
                                    LeapSynthereminDelegate,
                                    PatchCablerDelegate,
                                    SynthPatchDelegate,
                                    LoopDelegate> 
{
    AudioQueueSynth *synth;
    
    LeapSyntheremin *leapSyntheremin;
    
    NSURL *currentPatchUrl;
    
    MIDIClientRef midiClient;
    MIDIPortRef midiInput;
    MidiParser *midiParser;
    int currentNoteNumber;
    
    int keyboardCurrentOctave;
    
    bool paramNoteOn;
    BOOL equalTempered;
 
    LeapModulator *leapModulator[6];
    
    
    int tuningType;
}

@property (assign) IBOutlet NSWindow *window;





@property (weak) IBOutlet NSTextField *noleap_label;


//looper interface
@property (weak) IBOutlet NSButton *looper_record;
@property (weak) IBOutlet NSButton *looper_play;
@property (weak) IBOutlet NSLevelIndicator *looper_level;
- (IBAction)toggleLooperRecord:(id)sender;
- (IBAction)toggleLooperPlay:(id)sender;
- (IBAction)clickLooperUndo:(id)sender;
- (IBAction)clickLooperClear:(id)sender;


//controls
- (IBAction)changeControl:(id)sender;
- (IBAction)changeDetuneControl:(id)sender;
- (IBAction)toggleTuned:(id)sender;



/*
 * Menu actions
 */
- (IBAction)menuNewPatch:(id)sender;
- (IBAction)menuOpenPatch:(id)sender;
- (IBAction)menuSavePatch:(id)sender;
- (IBAction)menuSavePatchAs:(id)sender;
- (IBAction)menuClearPatch:(id)sender;




/* 
 * Outlets
 */
@property (weak) IBOutlet PatchCabler *patchCabler;


@property (weak) IBOutlet CSKnob *lfo_freq;
@property (weak) IBOutlet CSKnob *lfo_level;
@property (weak) IBOutlet CSRadioButtonSet *lfo_shape;

@property (weak) IBOutlet CSKnob *noise_level;
@property (weak) IBOutlet CSRadioButtonSet *noise_type;

@property (weak) IBOutlet CSKnob *filter_cutoff;
@property (weak) IBOutlet CSKnob *filter_resonance;

@property (weak) IBOutlet CSKnob *adsr_attack_0;
@property (weak) IBOutlet CSKnob *adsr_decay_0;
@property (weak) IBOutlet CSKnob *adsr_sustain_0;
@property (weak) IBOutlet CSKnob *adsr_release_0;
@property (weak) IBOutlet CSKnob *adsr_attack_1;
@property (weak) IBOutlet CSKnob *adsr_decay_1;
@property (weak) IBOutlet CSKnob *adsr_sustain_1;
@property (weak) IBOutlet CSKnob *adsr_release_1;

@property (weak) IBOutlet CSKnob *mixer_level;
@property (weak) IBOutlet CSFader *vca_level_0;
@property (weak) IBOutlet CSFader *vca_level_1;
@property (weak) IBOutlet CSFader *vca_level_2;

@property (weak) IBOutlet CSRadioButtonSet *osc_shape_0;
@property (weak) IBOutlet CSRadioButtonSet *osc_shape_1;
@property (weak) IBOutlet CSRadioButtonSet *osc_shape_2;

@property (weak) IBOutlet NSTabView *tabView;
- (IBAction)switchToSynth:(id)sender;
- (IBAction)switchToTheremin:(id)sender;

@property (weak) IBOutlet LeapCursorOverlay *cursorOverlay;
@property (weak) IBOutlet LinearAnalyzer *linearAnalyzer;
@property (weak) IBOutlet PolarAnalyzer *polarAnalyzer;


@property (weak) IBOutlet CSRadioButtonSet *wave_osc_0;

- (IBAction)changeTuning:(id)sender;

@end
