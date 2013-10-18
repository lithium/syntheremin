//
//  Synth.m
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "Synth.h"

@implementation Synth
@synthesize delegate;

- (id)init
{

    if (self) {
        self = [super init];
    
        for (int i=0; i < kNumOscillators; i++) {
            oscN[i] = [[Vco alloc] init];
            [oscN[i] setWaveShape:kWaveSquare];
            [oscN[i] setFrequencyInHz:440];
            [oscN[i] setRange:0];
        }
        for (int i=0; i < kNumEnvelopes; i++) {
            adsrN[i] = [[Adsr alloc] init];
        }

        lfo = [[Oscillator alloc] init];

        noise = [[NoiseGenerator alloc] init];
        vcf = [[Vcf alloc] init];
        mixer = [[Vca alloc] init];
        for (int i=0; i < kNumMixers; i++) {
            vcaN[i] = [[Vca alloc] init];
            [vcaN[i] setLevel:0];
            [mixer addInput:vcaN[i]];
        }

    }
    
    return self;
}

- (int) getSamples :(short *)samples :(int)numSamples
{
@autoreleasepool {
        
    [mixer getSamples:samples :numSamples];
    if (delegate && [delegate respondsToSelector:@selector(receiveSamples::)]) {
        [delegate receiveSamples:samples :numSamples];
    }
    return numSamples;
    
}
}

- (void)noteOn
{
    for (int i=0; i < kNumEnvelopes; i++) {
        [adsrN[i] noteOn];
    }
}

- (void)noteOff
{
    for (int i=0; i < kNumEnvelopes; i++) {
        [adsrN[i] noteOff];
    }
}

- (void)setFrequencyInHz:(double)freqInHz
{
    for (int i=0; i < kNumOscillators; i++) {
        [oscN[i] setFrequencyInHz:freqInHz];
    }
}

- (void)applyParameter:(NSString *)parameterName :(double)value
{
    __weak SampleProvider *component;
    NSString *param = [self parsePortName:parameterName :&component];
    
    [component setValue:[NSNumber numberWithDouble:value] 
                 forKey:param];

}
- (void)connectPatch:(NSString *)sourceName :(NSString *)targetName
{
    __weak SampleProvider *source;
    __weak Mixer *target;
    NSString *src_port = [self parsePortName:sourceName :&source];
    NSString *target_port = [self parsePortName:targetName :&target];
    
    if (![src_port isEqualToString:@"output"]) {
        return;
    }
    
    if ([target_port isEqualToString:@"input"]) {
        [target addInput:source];
    }
    else if ([target_port isEqualToString:@"modulate"]) {
        [target setModulator:source];
    }
    

}
- (void)disconnectPatch:(NSString *)sourceName :(NSString *)targetName
{
    __weak SampleProvider *source;
    __weak Mixer *target;
    NSString *src_port = [self parsePortName:sourceName :&source];
    NSString *target_port = [self parsePortName:targetName :&target];
    
    if ([target_port isEqualToString:@"input"]) {
        [target removeInput:source];
    }
    else if ([target_port isEqualToString:@"modulate"]) {
        [target setModulator:nil];
    }
    else if ([target_port isEqualToString:@"modulateMixer"]) {
        for (int i=0; i < kNumMixers; i++) {
            [vcaN[i] setModulator:nil];
        }
    }

}

        
        
- (NSString*)parsePortName:(NSString*)portString :(__weak id *)outComponent
{
    NSArray *chunks = [portString componentsSeparatedByString:@":"];
    if ([chunks count] >= 2 && outComponent) 
    {
        NSString *component = [chunks objectAtIndex:0];
        int index = [[chunks objectAtIndex:1] intValue];
        NSString *portName = [chunks objectAtIndex:2];
        
        if ([component isEqualToString:@"osc"]) {
            *outComponent = oscN[index];
        }
        else if ([component isEqualToString:@"vca"]) {
            *outComponent = vcaN[index];
        }
        else if ([component isEqualToString:@"adsr"]) {
            *outComponent = adsrN[index];
        }
        else if ([component isEqualToString:@"vcf"]) {
            *outComponent = vcf;
        }
        else if ([component isEqualToString:@"lfo"]) {
            *outComponent = lfo;
        }
        else if ([component isEqualToString:@"noise"]) {
            *outComponent = noise;
        }
        else if ([component isEqualToString:@"master"]) {
            *outComponent = self;
        }
        else if ([component isEqualToString:@"mixer"]) {
            *outComponent = mixer;
        }
        else {
            *outComponent = nil;
        }

        
        return portName;
    }
    
    return nil;

}

- (NSDictionary *)properties
{
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithCapacity:10];
    
    for (int i=0; i < kNumOscillators; i++) {
        [config setObject:[oscN[i] properties] 
                   forKey:[NSString stringWithFormat:@"osc:%d", i]];
    }
    for (int i=0; i < kNumEnvelopes; i++) {
        [config setObject:[adsrN[i] properties] 
                   forKey:[NSString stringWithFormat:@"adsr:%d", i]];
    }

    for (int i=0; i < kNumMixers; i++) {
        [config setObject:[vcaN[i] properties] 
                   forKey:[NSString stringWithFormat:@"vca:%d", i]];
    }

    [config setObject:[lfo properties] forKey:@"lfo:0"];
    [config setObject:[noise properties] forKey:@"noise:0"];
    [config setObject:[vcf properties] forKey:@"vcf:0"];
    [config setObject:[mixer properties] forKey:@"mixer::"];

    return config;

}

- (NSData *)currentConfiguration
{
    NSString *error;
    NSData *plist = [NSPropertyListSerialization dataFromPropertyList:[self properties]
                                                               format:NSPropertyListXMLFormat_v1_0
                                                     errorDescription:&error];
    if (!plist) {
        NSLog(@"error generating configuration: %@", error);
    }
    return plist;
}
@end
