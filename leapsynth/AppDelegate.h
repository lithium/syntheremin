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
#import "SynthAnalyzer.h"
#import "PatchCabler.h"

#import "CSKnob.h"
#import "CSFader.h"
#import "CSPopupButton.h"
#import "CSMultiSwitch.h"

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
}

@property (assign) IBOutlet NSWindow *window;





@property (weak) IBOutlet SynthAnalyzer *synthAnalyzer;
@property (weak) IBOutlet NSTextField *noleap_label;


//looper interface
@property (weak) IBOutlet NSButton *looper_record;
@property (weak) IBOutlet NSButton *looper_play;
@property (weak) IBOutlet NSLevelIndicator *looper_level;
- (IBAction)toggleLooperRecord:(id)sender;
- (IBAction)toggleLooperPlay:(id)sender;
- (IBAction)clickLooperUndo:(id)sender;
- (IBAction)clickLooperClear:(id)sender;


//button keyboard
@property (weak) IBOutlet NSBox *keyboardBox;
- (IBAction)changeControl:(id)sender;



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
@property (weak) IBOutlet CSMultiSwitch *lfo_shape;

@property (weak) IBOutlet CSKnob *noise_level;
@property (weak) IBOutlet CSMultiSwitch *noise_type;

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

@property (weak) IBOutlet CSMultiSwitch *osc_shape_0;
@property (weak) IBOutlet CSPopupButton *osc_range_0;
@property (weak) IBOutlet CSMultiSwitch *osc_shape_1;
@property (weak) IBOutlet CSPopupButton *osc_range_1;
@property (weak) IBOutlet CSKnob *osc_detune_1;
@property (weak) IBOutlet CSMultiSwitch *osc_shape_2;
@property (weak) IBOutlet CSPopupButton *osc_range_2;
@property (weak) IBOutlet CSKnob *osc_detune_2;

@property (weak) IBOutlet NSTabView *tabView;
- (IBAction)switchToSynth:(id)sender;
- (IBAction)switchToTheremin:(id)sender;


@end
