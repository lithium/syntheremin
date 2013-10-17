//
//  AppDelegate.m
//  leapsynth
//
//  Created by Wiggins on 7/29/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize patchCabler;
@synthesize keyboardBox;
@synthesize looper_level;
@synthesize looper_play;
@synthesize looper_record;

//@synthesize synthAnalyzer;
@synthesize noleap_label;



@synthesize window = _window;


static void handle_midi_input (const MIDIPacketList *list, void *inputUserdata, void *srcUserdata)
{
    AppDelegate *self = (__bridge AppDelegate *)inputUserdata;
    const MIDIPacket *packet = list->packet;
    
    for (int i = 0; i < list->numPackets; i++) {        
        [self->midiParser feedPacketData:(UInt8*)packet->data :packet->length];
        packet = MIDIPacketNext(packet);
    }
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
//    [_window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
            

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:_window];
    
    
    
    mSyntheremin = [[LeapSyntheremin alloc] init];
    [mSyntheremin setDelegate:self];
    
        
    synth = [[AudioQueueSynth alloc] init];
    [synth start];
        
    [[synth looper] setDelegate:self];
        

    OSStatus status;
    
    
    //set up patch cabler
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

        //vcas
        [patchCabler addEndpointWithType:kInputPatchEndpoint 
                        andParameterName:@"vca:0:input"
                                  onEdge:kEdgeBottom
                              withOffset:40];
        [patchCabler addEndpointWithType:kInputPatchEndpoint 
                        andParameterName:@"vca:0:modulate"
                                  onEdge:kEdgeBottom
                              withOffset:70];
        
        [patchCabler addEndpointWithType:kInputPatchEndpoint 
                        andParameterName:@"vca:1:input"
                                  onEdge:kEdgeBottom
                              withOffset:110];
        [patchCabler addEndpointWithType:kInputPatchEndpoint 
                        andParameterName:@"vca:1:modulate"
                                  onEdge:kEdgeBottom
                              withOffset:140];

        [patchCabler addEndpointWithType:kInputPatchEndpoint 
                        andParameterName:@"vca:2:input"
                                  onEdge:kEdgeBottom
                              withOffset:180];
        [patchCabler addEndpointWithType:kInputPatchEndpoint 
                        andParameterName:@"vca:2:modulate"
                                  onEdge:kEdgeBottom
                              withOffset:210];


        //envelopes
        [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                        andParameterName:@"env:0:output"
                                  onEdge:kEdgeRight
                              withOffset:150];
        [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                        andParameterName:@"env:1:output"
                                  onEdge:kEdgeRight
                              withOffset:50];

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



        //modulators
        [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                        andParameterName:@"lfo:0:output"
                                  onEdge:kEdgeTop
                              withOffset:50];
        [patchCabler addEndpointWithType:kOutputPatchEndpoint 
                        andParameterName:@"noise:0:output"
                                  onEdge:kEdgeTop
                              withOffset:250];

        
    }


    
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
    
    //set up the delegates for the keyboard buttons
    for (int i=40; i<=52; i++) {
        DownUpButton *key = [keyboardBox viewWithTag:i];
        [key setDelegate:self];
    }
    
    }
- (void)windowWillClose:(NSNotification *)notification
{
    [synth stop];
    [NSApp terminate:self];
}







#define kLeftXMin -200
#define kLeftXMax -70

#define kLeftYMin 150
#define kLeftYMax 500

#define kLeftZMin 0
#define kLeftZMax 120

#define kRightXMin 70
#define kRightXMax 200

#define kRightYMin 150
#define kRightYMax 500

#define kRightZMin 0
#define kRightZMax 120



- (void)leftHandMotion:(LeapHand *)hand :(LeapVector *)position
{
    double x = (MAX(MIN([position x], kLeftXMax), kLeftXMin) - kLeftXMin)/(kLeftXMax - kLeftXMin);
    double y = (MAX(MIN([position y], kLeftYMax), kLeftYMin) - kLeftYMin)/(kLeftYMax - kLeftYMin);
    double z = 1.0-(MAX(MIN([position z], kLeftZMax), kLeftZMin) - kLeftZMin)/(kLeftZMax - kLeftZMin);
    
//    NSLog(@"left x,y,z: %f,%f,%f",[position x],[position y],[position z]);
    
//    [self applyParameter:inputParams[kInputLeftHandX] :x];
//    [self applyParameter:inputParams[kInputLeftHandY] :y];
//    [self applyParameter:inputParams[kInputLeftHandZ] :z];
    
//    [synthAnalyzer setLeftHand:x :y :z];
}
- (void)rightHandMotion:(LeapHand *)hand :(LeapVector *)position
{
    double x = (MAX(MIN([position x], kRightXMax), kRightXMin) - kRightXMin)/(kRightXMax - kRightXMin);
    double y = (MAX(MIN([position y], kRightYMax), kRightYMin) - kRightYMin)/(kRightYMax - kRightYMin);
    double z = 1.0-(MAX(MIN([position z], kRightZMax), kRightZMin) - kRightZMin)/(kRightZMax - kRightZMin);
//    NSLog(@"right x,y,z: %f,%f,%f",[position x],[position y],[position z]);

//    [self applyParameter:inputParams[kInputRightHandX] :x];
//    [self applyParameter:inputParams[kInputRightHandY] :y];
//    [self applyParameter:inputParams[kInputRightHandZ] :z];

//    [synthAnalyzer setRightHand:x :y :z];

}
- (void)leftHandTap:(LeapHand *)hand :(LeapGesture *)gesture
{   
//    [self applyParameter:inputParams[kInputLeftHandTap] :!paramNoteOn];
}
- (void)rightHandTap:(LeapHand *)hand :(LeapGesture *)gesture
{
//    [self applyParameter:inputParams[kInputRightHandTap] :!paramNoteOn];

}
- (void)onConnect
{
    [noleap_label setHidden:YES];
}
- (void)onDisconnect
{
    [noleap_label setHidden:NO];
}

//- (void)applyParameter:(int)param :(double)value
//{
//    switch (param) {
//        case kParameterVolume:
//            [[synth vca] setMasterVolume:value];
//            [vca_master setDoubleValue:value];
//            break;
//        case kParameterPitch: {
//            double detune = (value*kCentsPerOctave);
//            [[synth osc1] setDetuneInCents:kCentsPerOctave-detune];
//            [osc1_freq setDoubleValue:detune];
//            break;
//        }
//        case kParameterFrequency: {
//            double freq = value*(kFrequencyMax-kFrequencyMin)+kFrequencyMin;
//            [[synth vcf] setCutoffFrequencyInHz:freq];
//            [vcf_cutoff setDoubleValue:freq];
//            break;
//        }
//        case kParameterResonance: {
//            [[synth vcf] setResonance:value];
//            [vcf_resonance setDoubleValue:value];
//            break;
//        }
//        case kParameterLfoSpeed: {
//            double freq = value*(kLfoFrequencyMax-kLfoFrequencyMin)+kLfoFrequencyMin;
//            [[synth osc1] setLfoFrequency:freq];
//            [lfo_freq setDoubleValue:freq];
//            break;
//        }
//        case kParameterLfoAmount: {
//            [[synth osc1] setModulationAmount:value];
//            [lfo_amount setDoubleValue:value];
//            break;
//        }
//        case kParameterNote: {
//            if (value > kNoteThreshold) {
//                if (!paramNoteOn) { 
//                    [self noteOn];
//                    paramNoteOn = true;
//                }
//            } else {
//                if (paramNoteOn) {
//                    [self noteOff];
//                    paramNoteOn = false;
//                }
//            }
//            break;
//        }
//        case kParameterVcaEnvelope: {
//            bool state = ![vca_enable state];
//            [self setVcaEnvelopeEnabled:state];
//            [vca_enable setState:state];
//            break;
//        }
//        case kParameterFilterEnable: {
//            bool state = ![vcf_enable state];
//            [self setVcfEnabled:state];
//            [vcf_enable setState:state];
//            break;
//        }
//        case kParameterFilterEnvelope: {
//            bool state = ![vcf_envelope_enable state];
//            [self setVcfEnvelopeEnabled:state];
//            [vcf_envelope_enable setState:state];
//            break;
//        }
//        case kParameterVcoWaveshape: {
//            int value = [self incrementAndClampSlider:osc1_shape];
//            [[synth osc1] setWaveShape:value];
//            break;
//        }
//        case kParameterLfoWaveshape: {
//            int value = [self incrementAndClampSlider:lfo_shape];
//            [[synth osc1] setLfoWaveshape:value];
//            break;
//        }
//        case kParameterLfoModulation: {
//            int value = [self incrementAndClampSlider:lfo_type];
//            [[synth osc1] setModulationType:value];
//            break;
//        }
//        case kParameterRangeUp: {
//            int value = [self incrementAndClampSlider:osc1_range];
//            [[synth osc1] setRange:value];
//            break;
//        }
//        case kParameterRangeDown: {
//            int value = [self decrementAndClampSlider:osc1_range];
//            [[synth osc1] setRange: value];
//            break;
//        }
//
//    }
//}
//- (int)incrementAndClampSlider:(NSSlider *)slider
//{
//    int value = [slider intValue]+1;
//    int max = [slider maxValue];
//    int min = [slider minValue];
//    if (value >= max) 
//        value = min;
//    [slider setIntValue:value];
//    return value;
//
//}
//- (int)decrementAndClampSlider:(NSSlider *)slider
//{
//    int value = [slider intValue]-1;
//    int max = [slider maxValue];
//    int min = [slider minValue];
//    if (value < min) 
//        value = max-1;
//    [slider setIntValue:value];
//    return value;
//    
//}





- (void)noteOn
{        
    [synth noteOn];
}

- (void)noteOff
{
    [synth noteOff];
}


// delgate callbacks
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

- (void)mouseDown:(NSEvent *)evt :(int)tag {
    int noteNumber = tag + (kNotesPerOctave*keyboardCurrentOctave);
    [self noteOn:noteNumber withVelocity:64 onChannel:0];    
}
- (void)mouseUp:(NSEvent *)evt :(int)tag {
    [self noteOff:currentNoteNumber withVelocity:64 onChannel:0];
}

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


- (IBAction)clickKeyboardChangeOctave:(id)sender {
    int ofs = [sender tag];
    keyboardCurrentOctave += ofs;
}

- (IBAction)changeControl:(id)sender {
    double value = [sender doubleValue];
    NSString *param = [sender valueForKey:@"parameter"];
    NSLog(@"%@ = %f", param, value);
    
    [synth applyParameter:param :value];
}

@end
