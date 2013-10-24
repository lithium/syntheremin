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
@synthesize keyboardBox;
@synthesize looper_level;
@synthesize looper_play;
@synthesize looper_record;

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
@synthesize osc_range_0;
@synthesize osc_detune_1;
@synthesize osc_shape_1;
@synthesize osc_detune_2;
@synthesize tabView;
@synthesize osc_shape_2;
@synthesize osc_range_1;
@synthesize osc_range_2;


@synthesize polarAnalyzer;
@synthesize wave_osc_0;
@synthesize noleap_label;



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

    //we want to quit on window close
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:_window];
    
    
    //so we get keyUp/keyDown events
    [_window makeFirstResponder:self];
    
    
    //set up leap motion theremin
    leapSyntheremin = [[LeapSyntheremin alloc] init];
    [leapSyntheremin setDelegate:self];
    
        
    //start soft synth
    synth = [[AudioQueueSynth alloc] init];
    [synth start];
    
    //set up synth delegates
    [synth setPatchDelegate:self];
    [[synth looper] setDelegate:self];


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
    [[synth oscN:0] addObserver:self forKeyPath:@"range" options:0 context:(__bridge void *)osc_range_0];
    [[synth oscN:1] addObserver:self forKeyPath:@"waveShape" options:0 context:(__bridge void *)osc_shape_1];
    [[synth oscN:1] addObserver:self forKeyPath:@"detuneInCents" options:0 context:(__bridge void *)osc_detune_1];
    [[synth oscN:1] addObserver:self forKeyPath:@"range" options:0 context:(__bridge void *)osc_range_1];
    [[synth oscN:2] addObserver:self forKeyPath:@"waveShape" options:0 context:(__bridge void *)osc_shape_2];
    [[synth oscN:2] addObserver:self forKeyPath:@"detuneInCents" options:0 context:(__bridge void *)osc_detune_2];
    [[synth oscN:2] addObserver:self forKeyPath:@"range" options:0 context:(__bridge void *)osc_range_2];
    
    [self initializePatchCabler];

    //have synth re-set defaults so KVO can update outlets
    [synth setDefaults];
        
        
    for (int i=0; i < 6; i++) {
        leapModulator[i] = [[LeapModulator alloc] init];
    }
    //hardcode classic theremin
    [[synth mixer] setModulator:leapModulator[1]];
//    [leapModulator[1] setInverted:YES];
    equalTempered = YES;
    
    [[synth vcf] setModulator:leapModulator[4]];

    //listen to any available midi devices
    [self performSelectorInBackground:@selector(initializeMidi) withObject:nil];
    
}


- (void)windowWillClose:(NSNotification *)notification
{
    [synth stop];
    [NSApp terminate:self];
}


- (void)initializeMidi
{    
    OSStatus status;

    //connect all midi endpoints to our listener
    midiParser = [[MidiParser alloc] init];
    [midiParser setDelegate:self];
    status = MIDIClientCreate(CFSTR("Syntheremin"), NULL, NULL, &midiClient);
    status = MIDIInputPortCreate(midiClient, CFSTR("Input"), handle_midi_input, (__bridge void*)self, &midiInput);
    int num_midi = MIDIGetNumberOfDevices();
    for (int i=0; i < num_midi; i++) {
        MIDIEndpointRef src = MIDIGetSource(i);
        CFStringRef srcName;
        MIDIObjectGetStringProperty(src, kMIDIPropertyName, &srcName);
        status = MIDIPortConnectSource(midiInput, src, NULL);
    }
    

}


- (void)initializePatchCabler
{
    [patchCabler setDelegate:self];
    
    //oscilattors
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"osc:0:modulate"
                              onEdge:kEdgeLeft
                          withOffset:-60];
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"osc:0:output"
                              onEdge:kEdgeLeft
                          withOffset:-100];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"osc:1:modulate"
                              onEdge:kEdgeLeft
                          withOffset:-150];
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"osc:1:output"
                              onEdge:kEdgeLeft
                          withOffset:-200];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"osc:2:modulate"
                              onEdge:kEdgeLeft
                          withOffset:-250];
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"osc:2:output"
                              onEdge:kEdgeLeft
                          withOffset:-300];
    //lfo
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"lfo:0:output"
                              onEdge:kEdgeLeft
                          withOffset:16];

    //vcas
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vca:0:input"
                              onEdge:kEdgeBottom
                          withOffset:50];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vca:1:input"
                              onEdge:kEdgeBottom
                          withOffset:110];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vca:2:input"
                              onEdge:kEdgeBottom
                          withOffset:180];
    
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"mixer::modulate"
                              onEdge:kEdgeBottom
                          withOffset:240];
    
    
    
    //envelopes
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"adsr:0:output"
                              onEdge:kEdgeRight
                          withOffset:150];
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"adsr:1:output"
                              onEdge:kEdgeRight
                          withOffset:50];
    
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"noise:0:output"
                              onEdge:kEdgeRight
                          withOffset:16];
    

    //filter
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vcf:0:modulate"
                              onEdge:kEdgeRight
                          withOffset:-50];
    [patchCabler addEndpointWithType:kInputPatchEndpoint 
                    andParameterName:@"vcf:0:input"
                              onEdge:kEdgeRight
                          withOffset:-80];
    [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                    andParameterName:@"vcf:0:output"
                              onEdge:kEdgeRight
                          withOffset:-110];
    
    
    
    
}

- (void)noteOn
{        
    [synth noteOn];
    [polarAnalyzer shedRipple];
}

- (void)noteOff
{
    [polarAnalyzer shedRipple];
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


/*
 * Delegate Callbacks
 */

//looper delegate
- (void) samplesPlayed :(short *)samples :(int)numSamples
{
    @autoreleasepool {
        [looper_level setIntValue:[looper_level intValue]+numSamples];
    }
}
- (void) loopReset
{
    @autoreleasepool {
        [looper_level setIntValue:0];
    }
}


//midi delegate
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


//patch cabler delegate, ui events
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

//synth patch delegate, model events
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
    [control setDoubleValue:[value doubleValue]];

}

//window key events
- (void)keyDown:(NSEvent*)theEvent
{
    char key = [[theEvent characters] characterAtIndex:0];
    int noteNumber;
    switch (key) {
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
    }
    
    noteNumber += (kNotesPerOctave*keyboardCurrentOctave);
    [self noteOn:noteNumber withVelocity:64 onChannel:0];    

}
- (void)keyUp:(NSEvent*)theEvent
{
    [self noteOff:currentNoteNumber withVelocity:64 onChannel:0];
}




/*
 * LeapSyntheremin delegate
 */


- (void)leftHandMotion:(LeapHand *)hand :(LeapVector *)normal
{
    [cursorOverlay setLeftHand:normal.x :normal.y :normal.z];
    
    [leapModulator[0] setLevel:normal.x];
    [leapModulator[1] setLevel:normal.y];
    [leapModulator[2] setLevel:normal.z];
}
- (void)rightHandMotion:(LeapHand *)hand :(LeapVector *)normal
{
    [cursorOverlay setRightHand:normal.x :normal.y :normal.z];
    
    [leapModulator[3] setLevel:normal.x];
    [leapModulator[4] setLevel:normal.y];
    [leapModulator[5] setLevel:normal.z];
    

// 2 octaves starting at middle C
#define firstNote 40      
#define lastNote 64
    
    if (equalTempered) {
        int noteNumber = (normal.x * (lastNote-firstNote)) + firstNote;
        if (noteNumber != currentNoteNumber)
            [self noteOn:noteNumber withVelocity:64 onChannel:0];    
    } else {
        double minFreq = [MidiParser frequencyFromNoteNumber:35];
        double maxFreq = [MidiParser frequencyFromNoteNumber:70];
        double freq = (normal.x * (maxFreq - minFreq)) + minFreq;
        [synth setFrequencyInHz:freq];
    }
    
    

}
- (void)leftHandTap:(LeapHand *)hand :(LeapGesture *)gesture
{   
}
- (void)rightHandTap:(LeapHand *)hand :(LeapGesture *)gesture
{
}
- (void)onConnect
{
    [noleap_label setHidden:YES];
}
- (void)onDisconnect
{
    [noleap_label setHidden:NO];
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





/*
 * IB Actions
 */

- (IBAction)toggleLooperRecord:(id)sender {
    int state = [looper_record state];
    if (state) {
        [looper_level setIntValue:0];
        [looper_level setMaxValue:1000000];
        [looper_level setCriticalValue:0.1];
        [[synth looper] recordNewLoop];
    } else {
        [looper_level setIntValue:0];
        [looper_level setMaxValue:0];
        [looper_level setCriticalValue:0];
        [[synth looper] stopRecording];
    }

}
- (IBAction)toggleLooperPlay:(id)sender {

    int state = [looper_play state];
    if (state) {
        [looper_level setIntValue:0];
        [looper_level setMaxValue:[[synth looper] longestLoopSize]];
        [looper_level setCriticalValue:0];
        [[synth looper] playAll];
    } else {
        [looper_level setIntValue:0];
        [looper_level setMaxValue:0];
        [looper_level setCriticalValue:0];
        [[synth looper] stopPlayback];
    }
        
}



- (IBAction)clickLooperUndo:(id)sender {
    [[synth looper] undoLastLoop];
}

- (IBAction)clickLooperClear:(id)sender {
    [[synth looper] clearAllLoops];
}



- (IBAction)changeControl:(id)sender {
    double value = [sender doubleValue];
    NSString *param = [sender valueForKey:@"parameter"];
    [synth applyParameter:param :value];
}

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
- (IBAction)switchToSynth:(id)sender {
    [synth setAnalyzerDelegate:linearAnalyzer];
    [tabView selectTabViewItemAtIndex:0];
}

- (IBAction)switchToTheremin:(id)sender {
    [synth setAnalyzerDelegate:polarAnalyzer];
    [tabView selectTabViewItemAtIndex:1];
}
@end
