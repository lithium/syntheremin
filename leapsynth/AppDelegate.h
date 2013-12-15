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
#import "CSOnOffLabel.h"
#import "DetuneDial.h"
#import "TutorialBox.h"

enum {
    kTuningNone=0,
    kTuningMajor=1,
    kTuningHarmonicMinor=2,
    kTuningBlues=3,

};

@interface AppDelegate : NSResponder <NSApplicationDelegate
                                     ,LeapSynthereminDelegate
                                     ,PatchCablerDelegate
                                     ,SynthPatchDelegate
                                     ,TutorialDelegate
                                     >
{
    AudioQueueSynth *synth;
    
    LeapSyntheremin *leapSyntheremin;
    
    NSURL *currentPatchUrl;
    
    MIDIClientRef midiClient;
    MIDIPortRef midiInput;
    MidiParser *midiParser;
    int currentNoteNumber;
    
    int keyboardCurrentOctave;
    
    
    NSRect savedFrame;
    id currentAnalyzer;
    id lastAnalyzer;
    int tuningType;
    
    BOOL _completedTutorial;
}

@property (assign) IBOutlet NSWindow *window;









/*
 * Control Actions
 */

- (IBAction)changeControl:(id)sender;
- (IBAction)changeDetuneControl:(id)sender;
- (IBAction)switchToSynth:(id)sender;
- (IBAction)switchToTheremin:(id)sender;
- (IBAction)changeTuning:(id)sender;
- (IBAction)toggleTuned:(id)sender;



/*
 * Menu actions
 */
- (IBAction)menuNewPatch:(id)sender;
- (IBAction)menuOpenPatch:(id)sender;
- (IBAction)menuSavePatch:(id)sender;
- (IBAction)menuSavePatchAs:(id)sender;
- (IBAction)menuClearPatch:(id)sender;

- (IBAction)startTutorial:(id)sender;



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
@property (weak) IBOutlet DetuneDial *osc_detune_0;
@property (weak) IBOutlet DetuneDial *osc_detune_1;
@property (weak) IBOutlet DetuneDial *osc_detune_2;

@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSBox *fullscreenView;
@property (weak) IBOutlet NSView *thereminView;

@property (weak) IBOutlet LeapCursorOverlay *cursorOverlay;
@property (weak) IBOutlet LinearAnalyzer *linearAnalyzer;
@property (weak) IBOutlet PolarAnalyzer *polarAnalyzer;
@property (weak) IBOutlet PolarAnalyzer *fullscreenAnalyzer;



@property (weak) IBOutlet CSRadioButtonSet *wave_osc_0;


@property (weak) IBOutlet NSTextField *midiConnectedLabel;
@property (weak) IBOutlet NSTextField *leapConnectedLabel;
@property (weak) IBOutlet CSOnOffLabel *leapConnected;
@property (weak) IBOutlet NSTextField *leapDisconnectedLabel;

@property (weak) IBOutlet CSRadioButtonSet *tuningScale;
@property (weak) IBOutlet CSToggleButton *tunedButton;

@property (weak) IBOutlet TutorialBox *tutorialBox;
@property (weak) IBOutlet NSTextField *tutorialText;

@end
