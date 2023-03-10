//
//  Synth.h
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vco.h"
#import "Vca.h"
#import "Vcf.h"
#import "NoiseGenerator.h"
#import "Adsr.h"
#import "SampleProvider.h"

#define kNumMixers 4
#define kNumOscillators 3
#define kNumEnvelopes 2

@protocol AnalyzerDelegate <NSObject>
- (void) receiveSamples :(id)sender :(short *)samples :(int)numSamples;
@end

@protocol SynthPatchDelegate <NSObject>
- (void)connectPatch:(NSString *)sourceName :(NSString *)targetName;
- (void)disconnectPatch:(NSString *)sourceName :(NSString *)targetName;
@end

@interface Synth : SampleProvider {
    Vco *oscN[kNumOscillators];
    Oscillator *lfo;
    NoiseGenerator *noise;
    Vcf *vcf;
    Adsr *adsrN[kNumEnvelopes];
    Vca *vcaN[kNumMixers];
    Vca *mixer;
    
    NSMutableDictionary *patches;
    __weak id delegate;
}

@property (weak) id analyzerDelegate;
@property (weak) id patchDelegate;

- (id)init;

@property (readonly) Mixer *mixer;
@property (readonly) Vcf *vcf;
@property (readonly) Oscillator *lfo;
@property (readonly) NoiseGenerator *noise;

@property (readonly) double frequencyInHz;

- (Vca *)vcaN:(int)i;
- (Adsr *)adsrN:(int)i;
- (Vco *)oscN:(int)i;

- (int)getSamples :(short *)samples :(int)numSamples;


- (void)setFrequencyInHz:(double)freqInHz;
- (void)noteOn;
- (void)noteOff;

- (void)applyParameter:(NSString *)parameterName :(double)value;
- (void)connectPatch:(NSString *)sourceName :(NSString *)targetName;
- (void)disconnectPatch:(NSString *)sourceName :(NSString *)targetName;

- (NSDictionary *)properties;
- (NSData *)currentConfiguration;
- (BOOL)setConfiguration:(NSDictionary *)config;

- (void)setDefaults;

@end
