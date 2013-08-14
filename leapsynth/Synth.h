//
//  Synth.h
//  leapsynth
//
//  Created by Wiggins on 8/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vco.h"
#import "Vca.h"
#import "Vcf.h"
#import "SynthAnalyzer.h"

@protocol AnalyzerDelegate <NSObject>
- (void) receiveSamples :(short *)samples :(int)numSamples;
@end

@interface Synth : NSObject {
    Vco *vco;
    Vca *vca;
    Vcf *vcf;
    
    bool vcfEnabled;
    bool vcaEnabled;
}

@property Vco *vco;
@property Vca *vca;
@property Vcf *vcf;
@property bool vcfEnabled;
@property bool vcaEnabled;
@property (weak) id <AnalyzerDelegate> analyzer;


- (id)init;
- (int) getSamples :(short *)samples :(int)numSamples;


- (void)noteOn;
- (void)noteOff;

@end
