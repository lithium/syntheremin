//
//  AppDelegate.m
//  leapsynth
//
//  Created by Wiggins on 7/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize lefthand_tap_popup;
@synthesize righthand_tap_popup;
@synthesize synthAnalyzer;
@synthesize lefthand_box;
@synthesize righthand_box;
@synthesize noleap_label;
@synthesize patch_predicateeditor;
@synthesize vca_note;
@synthesize vca_enable;

@synthesize vca_master;
@synthesize vcf_envelope_enable;
@synthesize vcf_enable;
@synthesize lefthand_x;
@synthesize lefthand_y;
@synthesize lefthand_z;
@synthesize righthand_x;
@synthesize righthand_y;
@synthesize righthand_z;
@synthesize lefthand_x_popup;
@synthesize lefthand_y_popup;
@synthesize lefthand_z_popup;
@synthesize righthand_x_popup;
@synthesize righthand_y_popup;
@synthesize righthand_z_popup;

@synthesize vcf_cutoff;
@synthesize vcf_resonance;
@synthesize vcf_depth;
@synthesize vcf_attack;
@synthesize vcf_decay;
@synthesize vcf_sustain;
@synthesize vcf_release;
@synthesize vca_attack;
@synthesize vca_decay;
@synthesize vca_sustain;
@synthesize vca_release;
@synthesize keyboard_1;
@synthesize keyboard_2;
@synthesize keyboard_3;
@synthesize keyboard_4;
@synthesize keyboard_5;
@synthesize cv_1;
@synthesize cv_2;
@synthesize cv_3;
@synthesize cv_4;
@synthesize cv_5;
@synthesize osc1_shape;
@synthesize osc1_range;
@synthesize osc1_detune;
@synthesize osc1_freq;
@synthesize osc2_shape;
@synthesize osc2_freq;
@synthesize osc2_amount;
@synthesize osc2_type;

@synthesize window = _window;
@synthesize drawer;


void audio_queue_output_callback(void *userdata, AudioQueueRef queue_ref, AudioQueueBufferRef buffer_ref)
{
    OSStatus ret;
    Synth *synth = (__bridge Synth *)userdata;
    AudioQueueBuffer *buffer = buffer_ref;
    int num_samples = buffer->mAudioDataByteSize / 2;
    short *samples = buffer->mAudioData;
    
    [synth getSamples:samples :num_samples];
    ret = AudioQueueEnqueueBuffer(queue_ref, buffer_ref, 0, NULL);
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [_window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    
    OSStatus status;
        
    synth = [[Synth alloc] init];
    [[synth vca] setMasterVolume:0];

    AudioStreamBasicDescription fmt = {0};
    fmt.mSampleRate = kSampleRate;
    fmt.mFormatID = kAudioFormatLinearPCM;
    fmt.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    fmt.mFramesPerPacket = 1;
    fmt.mChannelsPerFrame = 1;
    fmt.mBitsPerChannel = 16;
    fmt.mBytesPerFrame = fmt.mBitsPerChannel/8;
    fmt.mBytesPerPacket = fmt.mBytesPerFrame*fmt.mFramesPerPacket;
    
    
    status = AudioQueueNewOutput(&fmt, audio_queue_output_callback, (__bridge void*)synth, NULL, NULL, 0, &mAudioQueue);
    
    for (int i=0; i < kNumBuffers; i++) {
        status = AudioQueueAllocateBuffer(mAudioQueue, kBufferSize, &mQueueBuffers[i]);
        AudioQueueBuffer *buffer = mQueueBuffers[i];
        buffer->mAudioDataByteSize = kBufferSize;
    }
    [self primeBuffers];
    
    status = AudioQueueSetParameter (mAudioQueue, kAudioQueueParam_Volume, 1.0);

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:_window];
    
    [keyboard_1 setDelegate:self];
    [keyboard_2 setDelegate:self];
    [keyboard_3 setDelegate:self];
    [keyboard_4 setDelegate:self];
    [keyboard_5 setDelegate:self];
    
    
    
    mSyntheremin = [[LeapSyntheremin alloc] init];
    [mSyntheremin setDelegate:self];
    
    
    
    memset(inputParams, kParameterNone, kInputEnumSize*sizeof(int));
    kParameterTypeArray = [[NSArray alloc] initWithObjects:kParameterTypeNamesArray];
    kInputTypeArray = [[NSArray alloc] initWithObjects:kInputTypeNamesArray];

    
    [[synth vco] setWaveShape:kWaveSaw];
    [[synth vco] setModulationType:kModulationTypeFrequency];
    [[synth vco] setLfoWaveshape:kWaveSine];
    [self setVcaEnvelopeEnabled:NO];

    [synth setAnalyzer:synthAnalyzer];
    
    AudioQueueStart(mAudioQueue, NULL);

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"\"Left Hand Y\" = \"Volume\" \
                                AND \"Right Hand X\" = \"Pitch\"\
                                AND \"Right Hand Z\" = \"Cutoff Frequency\"\
                              "];
    [patch_predicateeditor setObjectValue:predicate];
    [self changePredicate:self];
    
    [drawer toggle:self];
    

}
- (void)windowWillClose:(NSNotification *)notification
{
    AudioQueueStop(mAudioQueue, true);
    [NSApp terminate:self];
}


- (void)primeBuffers
{
    for (int i=0; i < kNumBuffers; i++) {
        audio_queue_output_callback((__bridge void*)synth, mAudioQueue, mQueueBuffers[i]);
    }
}



- (IBAction)setVcoShape:(id)sender {
    [[synth vco] setWaveShape:[osc1_shape intValue]];
    AudioQueueStop(mAudioQueue, true);
    [self primeBuffers];
    AudioQueueStart(mAudioQueue, NULL);
}

- (IBAction)setVcoRange:(id)sender {
    int value = [osc1_range intValue];
    [[synth vco] setRange:( value)];
}

- (IBAction)setVcoDetune:(id)sender {
    int value = [osc1_detune intValue];
    [[synth vco] setDetuneInCents:value];
}
- (IBAction)setVcoFrequency:(id)sender
{
    double freq = [osc1_freq doubleValue];
    [[synth vco] setDetuneInCents:kCentsPerOctave-freq];

}
- (IBAction)setLfoShape:(id)sender {
    int shape = [osc2_shape intValue];
    [[synth vco] setLfoWaveshape:shape];
}

- (IBAction)setLfoFrequency:(id)sender {
    [[synth vco] setLfoFrequency:[osc2_freq doubleValue]];
}

- (IBAction)setLfoType:(id)sender {
    [[synth vco] setModulationType:[osc2_type intValue]];
}

- (IBAction)setLfoAmount:(id)sender {
    [[synth vco] setModulationAmount:[osc2_amount doubleValue]];

}

- (IBAction)setVcaMaster:(id)sender;
{
    [[synth vca] setMasterVolume:[vca_master doubleValue]];
}
- (IBAction)setVcaAttack:(id)sender
{
    [[synth vca] setAttackTimeInMs:[vca_attack intValue]];
}

- (IBAction)setVcaDecay:(id)sender
{
    [[synth vca] setDecayTimeInMs:[vca_decay intValue]];

}

- (IBAction)setVcaSustain:(id)sender
{
    [[synth vca] setSustainLevel:[vca_sustain doubleValue]];

}
- (IBAction)setVcaRelease:(id)sender
{
    [[synth vca] setReleaseTimeInMs:[vca_release intValue]];

}

- (IBAction)setVcfAttack:(id)sender
{
    [[synth vcf] setAttackTimeInMs:[vcf_attack intValue]];
}

- (IBAction)setVcfDecay:(id)sender
{
    [[synth vcf] setDecayTimeInMs:[vcf_decay intValue]];
    
}

- (IBAction)setVcfSustain:(id)sender
{
    [[synth vcf] setSustainLevel:[vcf_sustain doubleValue]];
    
}
- (IBAction)setVcfRelease:(id)sender
{
    [[synth vcf] setReleaseTimeInMs:[vcf_release intValue]];
    
}
- (IBAction)setVcfCutoff:(id)sender
{
    [[synth vcf] setCutoffFrequencyInHz:[vcf_cutoff intValue]];
}
- (IBAction)setVcfResonance:(id)sender
{
    [[synth vcf] setResonance:[vcf_resonance doubleValue]];
}
- (IBAction)setVcfDepth:(id)sender
{
    double depth = [vcf_depth doubleValue];
    [[synth vcf] setDepth:depth];
}

- (IBAction)toggleVcfEnable:(id)sender {
    int state = [vcf_enable state];
    [self setVcfEnabled:state];
}

- (IBAction)toggleFilterEnvelope:(id)sender {
    int state = [vcf_envelope_enable state];
    [self setVcfEnvelopeEnabled:state];
}

- (IBAction)toggleVcaEnvelope:(id)sender {
    int state = [vca_enable state];
    [self setVcaEnvelopeEnabled:state];
}
- (IBAction)toggleVcaNote:(id)sender {
    int state = [vca_note state];
    [self setNoteOn:state];
}

- (void)setVcaEnvelopeEnabled:(bool)enabled 
{
    [[synth vca] setEnvelopeEnabled:enabled];
    [vca_attack setEnabled:enabled];
    [vca_decay setEnabled:enabled];
    [vca_sustain setEnabled:enabled];
    [vca_release setEnabled:enabled];
}
- (void)setVcfEnvelopeEnabled:(bool)enabled
{
    [[synth vcf] setEnvelopeEnabled:enabled];
    [vcf_attack setEnabled:enabled];
    [vcf_decay setEnabled:enabled];
    [vcf_sustain setEnabled:enabled];
    [vcf_release setEnabled:enabled];
    [vcf_depth setEnabled:enabled];
}
- (void)setVcfEnabled:(bool)enabled
{
    [synth setVcfEnabled:enabled];
    [vcf_cutoff setEnabled:enabled];
    [vcf_resonance setEnabled:enabled];
    [vcf_envelope_enable setEnabled:enabled];
    [vcf_attack setEnabled:enabled];
    [vcf_decay setEnabled:enabled];
    [vcf_sustain setEnabled:enabled];
    [vcf_release setEnabled:enabled];
    [vcf_depth setEnabled:enabled];
}
- (void)setNoteOn:(bool)noteOn
{
    if ((bool)noteOn) {
        [self noteOn];
    }
    else {
        [self noteOff];
    }

}

- (void)mouseDown:(NSEvent *)evt :(int)tag {
    double freq=440;
    switch (tag) {
        case 100:
            freq += [cv_1 intValue]; 
            break;
        case 101:
            freq += [cv_2 intValue]; 
            break;
        case 102:
            freq += [cv_3 intValue]; 
            break;
        case 103:
            freq += [cv_4 intValue]; 
            break;
        case 104:
            freq += [cv_5 intValue]; 
            break;
    }
    [[synth vco] setFrequency:freq];
    
    [self noteOn];

}
- (void)mouseUp:(NSEvent *)evt :(int)tag {
    [self noteOff];
}

- (double)translateMinMax:(double)pos :(double)min :(double)max
{
    return (abs(pos) + abs(min))/(abs(min)+abs(max));
}


#define kLeftXMin -200
#define kLeftXMax -70

#define kLeftYMin 80
#define kLeftYMax 450

#define kLeftZMin 0
#define kLeftZMax 120

#define kRightXMin 70
#define kRightXMax 200

#define kRightYMin 60
#define kRightYMax 450

#define kRightZMin 0
#define kRightZMax 120



- (void)leftHandMotion:(LeapHand *)hand :(LeapVector *)position
{
    double x = (MAX(MIN([position x], kLeftXMax), kLeftXMin) - kLeftXMin)/(kLeftXMax - kLeftXMin);
    double y = (MAX(MIN([position y], kLeftYMax), kLeftYMin) - kLeftYMin)/(kLeftYMax - kLeftYMin);
    double z = 1.0-(MAX(MIN([position z], kLeftZMax), kLeftZMin) - kLeftZMin)/(kLeftZMax - kLeftZMin);
    
    [self applyParameter:inputParams[kInputLeftHandX] :x];
    [self applyParameter:inputParams[kInputLeftHandY] :y];
    [self applyParameter:inputParams[kInputLeftHandZ] :z];
    
    [synthAnalyzer setLeftHand:x :y :z];
}
- (void)rightHandMotion:(LeapHand *)hand :(LeapVector *)position
{
    double x = (MAX(MIN([position x], kRightXMax), kRightXMin) - kRightXMin)/(kRightXMax - kRightXMin);
    double y = (MAX(MIN([position y], kRightYMax), kRightYMin) - kRightYMin)/(kRightYMax - kRightYMin);
    double z = 1.0-(MAX(MIN([position z], kRightZMax), kRightZMin) - kRightZMin)/(kRightZMax - kRightZMin);
    
    [self applyParameter:inputParams[kInputRightHandX] :x];
    [self applyParameter:inputParams[kInputRightHandY] :y];
    [self applyParameter:inputParams[kInputRightHandZ] :z];

    [synthAnalyzer setRightHand:x :y :z];

}
- (void)leftHandTap:(LeapHand *)hand :(LeapGesture *)gesture
{   
    [self applyParameter:inputParams[kInputLeftHandTap] :!paramNoteOn];
}
- (void)rightHandTap:(LeapHand *)hand :(LeapGesture *)gesture
{
    [self applyParameter:inputParams[kInputRightHandTap] :!paramNoteOn];

}
- (void)onConnect
{
    [lefthand_box setHidden:NO];
    [righthand_box setHidden:NO];
    [noleap_label setHidden:YES];
}
- (void)onDisconnect
{
    [lefthand_box setHidden:YES];
    [righthand_box setHidden:YES];
    
    [noleap_label setHidden:NO];

}

- (void)applyParameter:(int)param :(double)value
{
    switch (param) {
        case kParameterVolume:
            [[synth vca] setMasterVolume:value];
            [vca_master setDoubleValue:value];
            break;
        case kParameterPitch: {
            double detune = (value*kCentsPerOctave);
            [[synth vco] setDetuneInCents:kCentsPerOctave-detune];
            [osc1_freq setDoubleValue:detune];
            break;
        }
        case kParameterFrequency: {
            double freq = value*(kFrequencyMax-kFrequencyMin)+kFrequencyMin;
            [[synth vcf] setCutoffFrequencyInHz:freq];
            [vcf_cutoff setDoubleValue:freq];
            break;
        }
        case kParameterResonance: {
            [[synth vcf] setResonance:value];
            [vcf_resonance setDoubleValue:value];
            break;
        }
        case kParameterLfoSpeed: {
            double freq = value*(kLfoFrequencyMax-kLfoFrequencyMin)+kLfoFrequencyMin;
            [[synth vco] setLfoFrequency:freq];
            [osc2_freq setDoubleValue:freq];
            break;
        }
        case kParameterLfoAmount: {
            [[synth vco] setModulationAmount:value];
            [osc2_amount setDoubleValue:value];
            break;
        }
        case kParameterNote: {
            if (value > kNoteThreshold) {
                if (!paramNoteOn) { 
                    [self noteOn];
                    paramNoteOn = true;
                }
            } else {
                if (paramNoteOn) {
                    [self noteOff];
                    paramNoteOn = false;
                }
            }
            break;
        }
        case kParameterVcaEnvelope: {
            bool state = ![vca_enable state];
            [self setVcaEnvelopeEnabled:state];
            [vca_enable setState:state];
            break;
        }
        case kParameterFilterEnable: {
            bool state = ![vcf_enable state];
            [self setVcfEnabled:state];
            [vcf_enable setState:state];
            break;
        }
        case kParameterFilterEnvelope: {
            bool state = ![vcf_envelope_enable state];
            [self setVcfEnvelopeEnabled:state];
            [vcf_envelope_enable setState:state];
            break;
        }
        case kParameterVcoWaveshape: {
            int value = [self incrementAndClampSlider:osc1_shape];
            [[synth vco] setWaveShape:value];
            break;
        }
        case kParameterLfoWaveshape: {
            int value = [self incrementAndClampSlider:osc2_shape];
            [[synth vco] setLfoWaveshape:value];
            break;
        }
        case kParameterLfoModulation: {
            int value = [self incrementAndClampSlider:osc2_type];
            [[synth vco] setModulationType:value];
            break;
        }
        case kParameterRangeUp: {
            int value = [self incrementAndClampSlider:osc1_range];
            [[synth vco] setRange:value];
            break;
        }
        case kParameterRangeDown: {
            int value = [self decrementAndClampSlider:osc1_range];
            [[synth vco] setRange: value];
            break;
        }

    }
}

- (int)incrementAndClampSlider:(NSSlider *)slider
{
    int value = [slider intValue]+1;
    int max = [slider maxValue];
    int min = [slider minValue];
    if (value >= max) 
        value = min;
    [slider setIntValue:value];
    return value;

}
- (int)decrementAndClampSlider:(NSSlider *)slider
{
    int value = [slider intValue]-1;
    int max = [slider maxValue];
    int min = [slider minValue];
    if (value < min) 
        value = max-1;
    [slider setIntValue:value];
    return value;
    
}





- (void)noteOn
{        
    AudioQueueStop(mAudioQueue, true);
    [synth noteOn];
    [self primeBuffers];
    AudioQueueStart(mAudioQueue, NULL);
    
    [vca_note setState:true];
}

- (void)noteOff
{
    [synth noteOff];
    [vca_note setState:false];

}


- (IBAction)changePredicate:(id)sender {
    
    memset(inputParams, 0, kInputEnumSize*sizeof(int));
    for (int i=0; i < [patch_predicateeditor numberOfRows]; i++) {
        NSArray *values = [patch_predicateeditor displayValuesForRow:i];
        if ([values count] < 3)
            continue;
        int input = [kInputTypeArray indexOfObject:[values objectAtIndex:0]];
        int param = [kParameterTypeArray indexOfObject:[values objectAtIndex:2]];
        if (input != -1 && input < kInputEnumSize) {
            inputParams[input] = param;
        }
    }
}
@end
