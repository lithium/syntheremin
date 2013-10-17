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
#import "Looper.h"
#import "MidiParser.h"
#import "SynthAnalyzer.h"
#import "PatchCabler.h"


@interface AppDelegate : NSObject  <NSApplicationDelegate, 
                                    DownUpButtonDelegate, 
                                    LeapSynthereminDelegate, 
                                    PatchCablerDelegate,
                                    LoopDelegate> 
{
    AudioQueueSynth *synth;
    
    LeapSyntheremin *mSyntheremin;
        
    
    MIDIClientRef midiClient;
    MIDIPortRef midiInput;
    MidiParser *midiParser;
    int currentNoteNumber;
    
    int keyboardCurrentOctave;
    
    bool paramNoteOn;
}

@property (assign) IBOutlet NSWindow *window;



//note button delegate
- (void)mouseDown:(NSEvent *)evt :(int)tag;
- (void)mouseUp:(NSEvent *)evt :(int)tag;



//@property (weak) IBOutlet SynthAnalyzer *synthAnalyzer;
@property (weak) IBOutlet NSTextField *noleap_label;


//looper interface
@property (weak) IBOutlet NSButton *looper_record;
@property (weak) IBOutlet NSButton *looper_play;
@property (weak) IBOutlet NSLevelIndicator *looper_level;
- (IBAction)toggleLooperRecord:(id)sender;
- (IBAction)toggleLooperPlay:(id)sender;
- (IBAction)clickLooperUndo:(id)sender;
- (IBAction)clickLooperClear:(id)sender;


@property (weak) IBOutlet NSBox *keyboardBox;
- (IBAction)clickKeyboardChangeOctave:(id)sender;

- (IBAction)faderChange:(id)sender;


@property (weak) IBOutlet PatchCabler *patchCabler;

@end
