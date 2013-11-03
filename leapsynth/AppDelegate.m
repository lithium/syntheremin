//
//  AppDelegate.m
//  leapsynth
//
//  Created by Wiggins on 7/29/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "AppDelegate.h"




@implementation AppDelegate
@synthesize cursorOverlay;
@synthesize linearAnalyzer;
@synthesize patchCabler;

@synthesize lfo_freq;
@synthesize lfo_level;
@synthesize lfo_shape;

@synthesize noise_level;
@synthesize noise_type;

@synthesize filter_cutoff;
@synthesize filter_resonance;

@synthesize adsr_attack_0;
@synthesize adsr_decay_0;
@synthesize adsr_sustain_0;
@synthesize adsr_release_0;
@synthesize adsr_attack_1;
@synthesize adsr_decay_1;
@synthesize adsr_sustain_1;
@synthesize adsr_release_1;

@synthesize mixer_level;
@synthesize vca_level_0;
@synthesize vca_level_1;
@synthesize vca_level_2;

@synthesize osc_shape_0;
@synthesize osc_shape_1;
@synthesize osc_shape_2;
@synthesize osc_detune_0;
@synthesize osc_detune_1;
@synthesize osc_detune_2;

@synthesize tabView;


@synthesize polarAnalyzer;
@synthesize wave_osc_0;
@synthesize fullscreenAnalyzer;
@synthesize midiConnectedLabel;
@synthesize leapConnectedLabel;
@synthesize leapConnected;
@synthesize leapDisconnectedLabel;
@synthesize tuningScale;
@synthesize tunedButton;

@synthesize window = _window;


static void handle_midi_input (const MIDIPacketList *list, void *inputUserdata, void *srcUserdata)
{
    @autoreleasepool {

        AppDelegate *self = (__bridge AppDelegate *)inputUserdata;
        const MIDIPacket *packet = list->packet;
        
        for (int i = 0; i < list->numPackets; i++) {        
            [self->midiParser feedPacketData:(UInt8*)packet->data :packet->length];
            packet = MIDIPacketNext(packet);
        }
    }
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{            
    [_window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    
    [_window setBackgroundColor:[NSColor colorWithSRGBRed:39/255.0 green:39.0/255.0 blue:44/255.0 alpha:1.0]];

    // quit on window close
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:_window];
    
    
    // watch for full screen
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidEnterFullScreen:) name:NSWindowDidEnterFullScreenNotification object:_window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillEnterFullScreen:) name:NSWindowWillEnterFullScreenNotification object:_window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillExitFullScreen:) name:NSWindowWillExitFullScreenNotification object:_window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidExitFullScreen:) name:NSWindowDidExitFullScreenNotification object:_window];

    
    // get keyUp/keyDown events
    keyboardCurrentOctave = 1;
    [_window makeFirstResponder:self];
    
    
    //set up leap motion theremin
    leapSyntheremin = [[LeapSyntheremin alloc] init];
    [leapSyntheremin setDelegate:self];
    
        
    //start soft synth
    synth = [[AudioQueueSynth alloc] init];
    [synth start];
    
    //set up synth delegates
    [synth setPatchDelegate:self];


    //KVO for outlets
    [synth addObserver:self forKeyPath:@"lfo.frequencyInHz" options:0 context:(__bridge void *)lfo_freq];
    [synth addObserver:self forKeyPath:@"lfo.level" options:0 context:(__bridge void *)lfo_level];
    [synth addObserver:self forKeyPath:@"lfo.waveShape" options:0 context:(__bridge void *)lfo_shape];
    
    [synth addObserver:self forKeyPath:@"noise.level" options:0 context:(__bridge void *)noise_level];
    [synth addObserver:self forKeyPath:@"noise.noiseType" options:0 context:(__bridge void *)noise_type];

    [synth addObserver:self forKeyPath:@"vcf.cutoffFrequencyInHz" options:0 context:(__bridge void *)filter_cutoff];
    [synth addObserver:self forKeyPath:@"vcf.resonance" options:0 context:(__bridge void *)filter_resonance];
    

    [synth addObserver:self forKeyPath:@"mixer.level" options:0 context:(__bridge void *)mixer_level];
    [[synth vcaN:0] addObserver:self forKeyPath:@"level" options:0 context:(__bridge void *)vca_level_0];
    [[synth vcaN:1] addObserver:self forKeyPath:@"level" options:0 context:(__bridge void *)vca_level_1];
    [[synth vcaN:2] addObserver:self forKeyPath:@"level" options:0 context:(__bridge void *)vca_level_2];

    [[synth adsrN:0] addObserver:self forKeyPath:@"attackTimeInMs" options:0 context:(__bridge void *)adsr_attack_0];
    [[synth adsrN:0] addObserver:self forKeyPath:@"decayTimeInMs" options:0 context:(__bridge void *)adsr_decay_0];
    [[synth adsrN:0] addObserver:self forKeyPath:@"sustainLevel" options:0 context:(__bridge void *)adsr_sustain_0];
    [[synth adsrN:0] addObserver:self forKeyPath:@"releaseTimeInMs" options:0 context:(__bridge void *)adsr_release_0];
    [[synth adsrN:1] addObserver:self forKeyPath:@"attackTimeInMs" options:0 context:(__bridge void *)adsr_attack_1];
    [[synth adsrN:1] addObserver:self forKeyPath:@"decayTimeInMs" options:0 context:(__bridge void *)adsr_decay_1];
    [[synth adsrN:1] addObserver:self forKeyPath:@"sustainLevel" options:0 context:(__bridge void *)adsr_sustain_1];
    [[synth adsrN:1] addObserver:self forKeyPath:@"releaseTimeInMs" options:0 context:(__bridge void *)adsr_release_1];

    [[synth oscN:0] addObserver:self forKeyPath:@"waveShape" options:0 context:(__bridge void *)osc_shape_0];
    [[synth oscN:0] addObserver:self forKeyPath:@"detuneInCents" options:0 context:(__bridge void *)osc_detune_0];
//    [[synth oscN:0] addObserver:self forKeyPath:@"range" options:0 context:(__bridge void *)osc_range_0];
    [[synth oscN:1] addObserver:self forKeyPath:@"waveShape" options:0 context:(__bridge void *)osc_shape_1];
    [[synth oscN:1] addObserver:self forKeyPath:@"detuneInCents" options:0 context:(__bridge void *)osc_detune_1];
//    [[synth oscN:1] addObserver:self forKeyPath:@"range" options:0 context:(__bridge void *)osc_range_1];
    [[synth oscN:2] addObserver:self forKeyPath:@"waveShape" options:0 context:(__bridge void *)osc_shape_2];
    [[synth oscN:2] addObserver:self forKeyPath:@"detuneInCents" options:0 context:(__bridge void *)osc_detune_2];
//    [[synth oscN:2] addObserver:self forKeyPath:@"range" options:0 context:(__bridge void *)osc_range_2];
    
    [self initializePatchCabler];

    
    
    //set up our default patch
    [synth setDefaults];
    [[synth oscN:0] setWaveShape:kWaveSine];
    [[synth vcaN:2] setLevel:0.8];
    [synth connectPatch:@"osc:0:output" :@"vca:2:input"];

    [[synth oscN:1] setWaveShape:kWaveSine];
    [[synth oscN:1] setDetuneInCents:-5];
    [[synth vcaN:1] setLevel:0.5];
    [synth connectPatch:@"osc:1:output" :@"vca:1:input"];

    [[synth oscN:2] setWaveShape:kWaveSine];
    [[synth oscN:2] setDetuneInCents:-1200];
    [[synth vcaN:0] setLevel:0.8];
    [synth connectPatch:@"osc:2:output" :@"vca:0:input"];

    [[synth mixer] setLevel:0.8];
    [synth connectPatch:@"adsr:1:output" :@"mixer::modulate"];

    
    //listen to any available midi devices
    [self performSelectorInBackground:@selector(initializeMidi) withObject:nil];
    
    
    [self switchToTheremin:nil];
    [self noteOn];

    
    [self loadApplicationState];

    if (!_completedTutorial) {
        [self startTutorial:nil];
    }
}


- (void)windowWillClose:(NSNotification *)notification
{
    [self saveApplicationState];
    [synth stop];
    [NSApp terminate:self];
}
- (void)windowWillEnterFullScreen:(NSNotification *)notification
{
    [[tabView animator] setAlphaValue:0.0];
    [[fullscreenAnalyzer animator] setAlphaValue:1.0];
    
    [synth setAnalyzerDelegate:fullscreenAnalyzer];
    lastAnalyzer = currentAnalyzer;
    currentAnalyzer = fullscreenAnalyzer;
    savedFrame = [_window frame];
}


- (void)windowDidEnterFullScreen:(NSNotification *)notification
{
    NSRect newFrame = [[NSScreen mainScreen] frame];
    [_window setFrame:newFrame display:YES];
    [fullscreenAnalyzer setFrameSize:NSMakeSize(newFrame.size.width, newFrame.size.height)];
    [fullscreenAnalyzer setFrameOrigin:NSMakePoint(0,0)];
    
    [NSCursor setHiddenUntilMouseMoves:YES];
}
- (void)windowWillExitFullScreen:(NSNotification *)notification
{
    [[tabView animator] setAlphaValue:1.0];
    [[fullscreenAnalyzer animator] setAlphaValue:0.0];
    [synth setAnalyzerDelegate:lastAnalyzer];
    currentAnalyzer = lastAnalyzer;
    lastAnalyzer = fullscreenAnalyzer;
}
- (void)windowDidExitFullScreen:(NSNotification *)notification
{
    [_window setFrame:savedFrame display:YES];

}

- (void)initializeMidi
{    
    OSStatus status;

    //connect all midi endpoints to our listener
    midiParser = [[MidiParser alloc] init];
    [midiParser setDelegate:self];
    status = MIDIClientCreate(CFSTR("Syntheremin"), NULL, NULL, &midiClient);
    status = MIDIInputPortCreate(midiClient, CFSTR("Input"), handle_midi_input, (__bridge void*)self, &midiInput);
    long num_midi = MIDIGetNumberOfDevices();
    bool foundAnything=NO;
    for (long i=0; i < num_midi; i++) {
        MIDIEndpointRef src = MIDIGetSource(i);
        CFStringRef srcName;
        MIDIObjectGetStringProperty(src, kMIDIPropertyName, &srcName);
        if (srcName)
            foundAnything=YES;
        status = MIDIPortConnectSource(midiInput, src, NULL);
    }
    
    
    if (foundAnything) {
        [midiConnectedLabel setHidden:NO];
    }

}


- (void)initializePatchCabler
{
    [patchCabler setDelegate:self];
    
    //lfo
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"lfo:0:output"
                              onEdge:kEdgeLeft
                          withOffset:420
                           withColor:[NSColor colorWithSRGBRed:67/255.0
                                                         green:67/255.0
                                                          blue:103/255.0
                                                         alpha:1.0]];

    //oscilattors
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"osc:0:output"
                              onEdge:kEdgeLeft
                          withOffset:310
                           withColor:[NSColor colorWithSRGBRed:150/255.0
                                                         green:139/255.0
                                                          blue:89/255.0
                                                         alpha:1.0]];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"osc:0:modulate"
                              onEdge:kEdgeLeft
                          withOffset:265
                           withColor:[NSColor colorWithSRGBRed:76/255.0
                                                         green:76/255.0
                                                          blue:79/255.0
                                                         alpha:1.0]];

    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"osc:1:output"
                              onEdge:kEdgeLeft
                          withOffset:200
                           withColor:[NSColor colorWithSRGBRed:157/255.0
                                                         green:104/255.0
                                                          blue:104/255.0
                                                         alpha:1.0]];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"osc:1:modulate"
                              onEdge:kEdgeLeft
                          withOffset:155
                           withColor:[NSColor colorWithSRGBRed:76/255.0
                                                         green:76/255.0
                                                          blue:79/255.0
                                                         alpha:1.0]];
    
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"osc:2:output"
                              onEdge:kEdgeLeft
                          withOffset:90
                           withColor:[NSColor colorWithSRGBRed:88/255.0
                                                         green:138/255.0
                                                          blue:122/255.0
                                                         alpha:1.0]];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"osc:2:modulate"
                              onEdge:kEdgeLeft
                          withOffset:45
                           withColor:[NSColor colorWithSRGBRed:76/255.0
                                                         green:76/255.0
                                                          blue:79/255.0
                                                         alpha:1.0]];
    //vcas
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vca:0:input"
                              onEdge:kEdgeBottom
                          withOffset:35
                           withColor:[NSColor colorWithSRGBRed:150/255.0
                                                         green:85/255.0
                                                          blue:131/255.0
                                                         alpha:1.0]];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vca:1:input"
                              onEdge:kEdgeBottom
                          withOffset:92
                           withColor:[NSColor colorWithSRGBRed:150/255.0
                                                         green:85/255.0
                                                          blue:131/255.0
                                                         alpha:1.0]];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vca:2:input"
                              onEdge:kEdgeBottom
                          withOffset:149
                           withColor:[NSColor colorWithSRGBRed:150/255.0
                                                         green:85/255.0
                                                          blue:131/255.0
                                                         alpha:1.0]];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"mixer::modulate"
                              onEdge:kEdgeBottom
                          withOffset:265
                           withColor:[NSColor colorWithSRGBRed:76/255.0
                                                         green:76/255.0
                                                          blue:79/255.0
                                                         alpha:1.0]];
    
    
    //noise
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"noise:0:output"
                              onEdge:kEdgeRight
                          withOffset:420
                           withColor:[NSColor colorWithSRGBRed:139/255.0
                                                         green:139/255.0
                                                          blue:176/255.0
                                                         alpha:1.0]];

    
    

    //filter
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"vcf:0:output"
                              onEdge:kEdgeRight
                          withOffset:310
                           withColor:[NSColor colorWithSRGBRed:90/255.0
                                                         green:67/255.0
                                                          blue:98/255.0
                                                         alpha:1.0]];

    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vcf:0:input"
                              onEdge:kEdgeRight
                          withOffset:275
                           withColor:[NSColor colorWithSRGBRed:150/255.0
                                                         green:85/255.0
                                                          blue:131/255.0
                                                         alpha:1.0]];
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vcf:0:modulate"
                              onEdge:kEdgeRight
                          withOffset:239
                           withColor:[NSColor colorWithSRGBRed:76/255.0
                                                         green:76/255.0
                                                          blue:79/255.0
                                                         alpha:1.0]];

    
    //envelopes
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"adsr:0:output"
                              onEdge:kEdgeRight
                          withOffset:200
                           withColor:[NSColor colorWithSRGBRed:118/255.0
                                                         green:134/255.0
                                                          blue:120/255.0
                                                         alpha:1.0]];
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"adsr:1:output"
                              onEdge:kEdgeRight
                          withOffset:90
                           withColor:[NSColor colorWithSRGBRed:91/255.0
                                                         green:94/255.0
                                                          blue:51/255.0
                                                         alpha:1.0]];

    
    
}

- (IBAction)startTutorial:(id)sender;
{
    [self switchToTheremin:nil];
    [_tutorialBox setDelegate:self];
    
    NSView *content = [_window contentView];
    [content addSubview:_tutorialBox];
    
    [_window makeFirstResponder:_tutorialBox];
    [_tutorialBox startTutorial];

}
- (void)nextTutorialStep
{
    [_tutorialBox nextStep];
}
- (void)tutorialComplete
{
    _completedTutorial = YES;
    [_window makeFirstResponder:self];
}

- (void)noteOn
{        
    [synth noteOn];
    [currentAnalyzer shedRipple];
}

- (void)noteOff
{
    [currentAnalyzer shedRipple];
    [synth noteOff];
}

- (BOOL)loadPatchFromURL:(NSURL*)url
{
//    NSLog(@"open: %@", url);
    NSString *error;
    NSData *contents = [NSData dataWithContentsOfURL:url];
    id config = [NSPropertyListSerialization propertyListFromData:contents
                                     mutabilityOption:NSPropertyListImmutable 
                                               format:nil
                                     errorDescription:&error];
    
    [synth setConfiguration:config];
    return YES;
}
- (BOOL)savePatchToURL:(NSURL*)url
{    
    currentPatchUrl = url;
//    NSLog(@"save: %@", url);
    return [[synth currentConfiguration] writeToURL:url atomically:YES];
}

- (NSURL*)patchDirectoryURL
{
    NSArray *docs_dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *patch_dir = [[NSURL URLWithString:[docs_dir objectAtIndex:0]] URLByAppendingPathComponent:@"Syntheremin"];
    NSString *path = [patch_dir absoluteString];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES 
                                               attributes:nil 
                                                    error:nil];
    
    return [NSURL fileURLWithPath:path isDirectory:YES];
}


- (NSURL*)applicationSupportPlistURL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSURL *support_dir = [[NSURL fileURLWithPath:[paths objectAtIndex:0]] URLByAppendingPathComponent:@"Syntheremin"];
                           
    [[NSFileManager defaultManager] createDirectoryAtURL:support_dir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    return [support_dir URLByAppendingPathComponent:@"Syntheremin.plist"];
}

- (void)loadApplicationState
{
    NSDictionary *state = [NSDictionary dictionaryWithContentsOfURL:[self applicationSupportPlistURL]];

    _completedTutorial = (BOOL)[state objectForKey:@"completedTutorial"];
}
- (void)saveApplicationState
{
    NSMutableDictionary *state = [NSMutableDictionary dictionaryWithCapacity:2];
    [state setObject:[NSNumber numberWithBool:_completedTutorial] forKey:@"completedTutorial"];
    
    [state writeToURL:[self applicationSupportPlistURL] atomically:YES];
}




/*
 * Delegate Callbacks
 */

#pragma mark Midi Delegate
- (void)noteOn:(UInt8)noteNumber withVelocity:(UInt8)velocity onChannel:(UInt8)channel
{
    [synth setFrequencyInHz:[MidiParser frequencyFromNoteNumber:noteNumber]];
    currentNoteNumber = noteNumber;
    [self noteOn];
    
}
- (void)noteOff:(UInt8)noteNumber withVelocity:(UInt8)velocity onChannel:(UInt8)channel
{
    if (noteNumber == currentNoteNumber) {
        currentNoteNumber = -1;
        [self noteOff];            
    }
    
}


#pragma mark PatchCabler Delegate
- (void)patchConnected:(PatchCableEndpoint *)source :(PatchCableEndpoint *)target
{
    NSLog(@"connect: %@ -> %@", [source parameterName], [target parameterName]);
    [synth connectPatch:[source parameterName] :[target parameterName]];
}
- (void)patchDisconnected:(PatchCableEndpoint *)source :(PatchCableEndpoint *)target
{
    NSLog(@"disconnect %@ -> %@", [source parameterName], [target parameterName]);
    [synth disconnectPatch:[source parameterName] :[target parameterName]];

}

#pragma mark Synth Patching Delegate
- (void)connectPatch:(NSString *)sourceName :(NSString *)targetName
{
    [patchCabler connectEndpoints:sourceName :targetName];
}
- (void)disconnectPatch:(NSString *)sourceName :(NSString *)targetName
{
    [patchCabler disconnectEndpoints:sourceName :targetName];    
}


//cscontrol kvo
- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context
{
    id value = [object valueForKeyPath:keyPath];
    
    CSControl *control = (__bridge CSControl *)context;
//    NSLog(@"%@[%@] = %@", keyPath, context, value);
    if ([keyPath isEqualToString:@"detuneInCents"]) {
        [control setDoubleValue:-[value doubleValue]/100];
    } else {
        [control setDoubleValue:[value doubleValue]];
    }

}




#pragma mark First responder Events
- (void)keyDown:(NSEvent*)theEvent
{
    char key = [[theEvent characters] characterAtIndex:0];
    int noteNumber;
    switch (key) {
        case '\e': //escape
            if (([_window styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask) {
                [_window toggleFullScreen:self];
            }
            return;
        case 'a': noteNumber = 40; break;
        case 'w': noteNumber = 41; break;
        case 's': noteNumber = 42; break;
        case 'e': noteNumber = 43; break;
        case 'd': noteNumber = 44; break;
        case 'f': noteNumber = 45; break;
        case 't': noteNumber = 46; break;
        case 'g': noteNumber = 47; break;
        case 'y': noteNumber = 48; break;
        case 'h': noteNumber = 49; break;
        case 'u': noteNumber = 50; break;
        case 'j': noteNumber = 51; break;
        case 'k': noteNumber = 52; break;
        case 'o': noteNumber = 53; break;
        case 'l': noteNumber = 54; break;
        case 'p': noteNumber = 55; break;
        case ';': noteNumber = 56; break;
        case '\'': noteNumber = 57; break;
        case 'z': 
            keyboardCurrentOctave--;
            return;
        case 'x':
            keyboardCurrentOctave++;
            return;
        default:
            return;
    }
    noteNumber += (kNotesPerOctave*keyboardCurrentOctave);

    
    if (noteNumber == currentNoteNumber)
        return;
    
    [self noteOn:noteNumber withVelocity:64 onChannel:0];

}
- (void)keyUp:(NSEvent*)theEvent
{
    [self noteOff:currentNoteNumber withVelocity:64 onChannel:0];
}





#pragma mark LeapSyntheremin Delegate

- (void)leftHandMotion:(LeapHand *)hand :(LeapVector *)normal
{

    [cursorOverlay setLeftHand:normal.x :normal.y :normal.z];
    [cursorOverlay setLeftHandVisible:YES];

    [_tutorialBox leftHandMotion:normal.x :normal.y :normal.z];

    
    [synth setLevel:normal.y];
    
}
- (void)rightHandMotion:(LeapHand *)hand :(LeapVector *)normal
{
    
    [cursorOverlay setRightHand:normal.x :normal.y :normal.z];
    [cursorOverlay setRightHandVisible:YES];

    [_tutorialBox rightHandMotion:normal.x :normal.y :normal.z];

    
#define kMiddleC 40

    
    if (tuningType == kTuningNone) {
        double minFreq = 130;//[MidiParser frequencyFromNoteNumber:28];
        double maxFreq = 1046;//[MidiParser frequencyFromNoteNumber:76];
        double freq = (normal.x * (maxFreq - minFreq)) + minFreq;
        [synth setFrequencyInHz:freq];
    }
    else {
        int octave = MIN(3.0, floor(normal.y * 4));
        int noteNumber = kMiddleC+octave*12;
        
        int quadrant = (int)floor(normal.x*8);
        
        int scales[3][6] = {
            {2,4,5,7,9,11},  // major
            {2,3,5,7,8,11},  // harmonic minor
            {2,3,5,6,9,10},  // blues
//            {2,3,5,7,8,10},  // natural minor
        };
        
        

        if (quadrant > 6) {
            noteNumber += 12;
        }
        else if (quadrant > 0) {
            noteNumber += scales[tuningType-1][quadrant-1];
        }
        
        
        if (noteNumber != currentNoteNumber)
            [self noteOn:noteNumber withVelocity:64 onChannel:0];
        
    }
    
    
    
    

}
- (void)leftHandGone:(int32_t)hand_id
{
    [cursorOverlay setLeftHandVisible:NO];
    
    [synth setLevel:1.0];
    [synth setFrequencyInHz:0];
}
- (void)rightHandGone:(int32_t)hand_id
{
    [cursorOverlay setRightHandVisible:NO];
}
- (void)onConnect
{
    [leapConnectedLabel setHidden:NO];
    [leapDisconnectedLabel setHidden:YES];
    [leapConnected setToggled:YES];
    
}
- (void)onDisconnect
{
    [leapConnectedLabel setHidden:YES];
    [leapDisconnectedLabel setHidden:NO];
    [leapConnected setToggled:NO];
    
    [synth setLevel:1.0];
}

- (void)leftHandOpened:(LeapHand *)hand
{
    
}
- (void)leftHandClosed:(LeapHand *)hand
{
    
}
- (void)rightHandOpened:(LeapHand *)hand
{
    
}
- (void)rightHandClosed:(LeapHand *)hand
{
    
}






#pragma mark Control Actions

- (IBAction)changeControl:(id)sender {
    double value = [sender doubleValue];
    NSString *param = [sender valueForKey:@"parameter"];
    [synth applyParameter:param :value];
}

- (IBAction)changeDetuneControl:(id)sender {
    double value = [sender doubleValue];
    NSString *param = [sender valueForKey:@"parameter"];
    [synth applyParameter:param :-value*100];
}

- (IBAction)switchToSynth:(id)sender {
    lastAnalyzer = currentAnalyzer;
    currentAnalyzer = linearAnalyzer;
    
    [_tutorialBox switchToSynth];
    
    [synth setAnalyzerDelegate:linearAnalyzer];
    [tabView selectTabViewItemAtIndex:0];
}


- (IBAction)switchToTheremin:(id)sender {
    lastAnalyzer = currentAnalyzer;
    currentAnalyzer = polarAnalyzer;
    
    [_tutorialBox switchToTheremin];
    
    [synth setAnalyzerDelegate:polarAnalyzer];
    [tabView selectTabViewItemAtIndex:1];
}


- (IBAction)changeTuning:(id)sender {
    tuningType = [sender doubleValue]+1;
    tunedButton->toggled = YES;
    [tunedButton setNeedsDisplay:YES];
    
    [cursorOverlay setDrawGrid:YES];
    //    NSLog(@"tuning %d", tuning);
}

- (IBAction)toggleTuned:(id)sender
{
    BOOL toggled = tuningType != 0;
    
    if (toggled) {
        [tuningScale clearSelection];
        tuningType = 0;
        tunedButton->toggled = NO;
        [self noteOn];
    } else {
        tuningType = 1;
        [tuningScale setDoubleValue:0];
        tunedButton->toggled = YES;
    }
    [cursorOverlay setDrawGrid:tuningType];
    
}


#pragma mark Menu Actions

- (IBAction)menuNewPatch:(id)sender {
    [synth setDefaults];
    currentPatchUrl = nil;
}
- (IBAction)menuOpenPatch:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"csp"]];
    [openPanel setAllowsOtherFileTypes:NO];

    if ([openPanel runModal] == NSOKButton && [[openPanel URLs] count]) {
        
        NSURL *url = [[openPanel URLs] objectAtIndex:0];
        [self loadPatchFromURL:url];
        
        [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:url];
    }
}
- (IBAction)menuSavePatch:(id)sender {
    if (currentPatchUrl) {
        [self savePatchToURL:currentPatchUrl];
    }
    else {
        return [self menuSavePatchAs:sender];
    }
}
- (IBAction)menuSavePatchAs:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"csp"]];
    [savePanel setAllowsOtherFileTypes:NO];
    
    NSURL *patch_dir = [self patchDirectoryURL];
    if (patch_dir) {
        [savePanel setDirectoryURL:patch_dir];
    }
    
    if ([savePanel runModal] == NSOKButton) {
        NSURL *url = [savePanel URL];
        [self savePatchToURL:url];
    }
    
}
- (IBAction)menuClearPatch:(id)sender {
    [synth setDefaults];
}

- (void)application:(NSApplication*)sender openFiles:(NSArray*)filenames
{
    [self loadPatchFromURL:[NSURL fileURLWithPath:[filenames objectAtIndex:0]]];
}

@end
