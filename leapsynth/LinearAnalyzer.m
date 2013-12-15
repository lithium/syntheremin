//
//  SynthAnalyzer.m
//  leapsynth
//
//  Created by Wiggins on 8/13/13.
//  Copyright (c) 2013 Concentric Sky. All rights reserved.
//

#import "LinearAnalyzer.h"

@implementation LinearAnalyzer
@synthesize drawAxis;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        buffer = [[NSMutableData alloc] initWithCapacity:kLinearAnalyzerSamplesPerRipple*kLinearAnalyzerZoomRatio*2*sizeof(short)];
        
        waveColor = [NSColor colorWithSRGBRed:93/255.0 green:100/255.0 blue:122/255.0 alpha:1.0];
        majorAxisColor = [NSColor colorWithSRGBRed:75/255.0 green:82/255.0 blue:99/255.0 alpha:1];
        minorAxisColor = [NSColor colorWithSRGBRed:57/255.0 green:63/255.0 blue:75/255.0 alpha:1];
        
        
        minorAxisPath = [[NSBezierPath alloc] init];
        [minorAxisPath setLineWidth:0.2];
        
        majorAxisPath = [[NSBezierPath alloc] init];
        [majorAxisPath setLineWidth:0.5];
        
        int numTicks = 24;
        NSRect bounds = [self bounds];
        double step = (bounds.size.height) / (bounds.size.height/16);
        double j;
        
        //  minor axis ticks
        for (j=0; j < bounds.size.height; j += step) {
            [minorAxisPath moveToPoint:NSMakePoint(0,j)];
            [minorAxisPath lineToPoint:NSMakePoint(bounds.size.width,j)];
            
        }
        step = (bounds.size.width) / numTicks;
        for (j=0; j < bounds.size.width; j += step) {
            [minorAxisPath moveToPoint:NSMakePoint(j,0)];
            [minorAxisPath lineToPoint:NSMakePoint(j,bounds.size.height)];
        }
        //  major axis ticks
        [majorAxisPath moveToPoint:NSMakePoint(0,bounds.size.height/2)];
        [majorAxisPath lineToPoint:NSMakePoint(bounds.size.width,bounds.size.height/2)];

    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];
    
    
    // draw axis
    if ([self drawAxis]) {
        [minorAxisColor set];
        [minorAxisPath stroke];

        [majorAxisColor set];
        [majorAxisPath stroke];
    }

    // draw waveform
    [waveColor set];
    [wavePath stroke];
    
    [ctx restoreGraphicsState];
    
}


// reduces samples in place, returns new numSamples
+ (int)reduceSamples:(short*)samples :(int)numSamples :(int)zoomRatio
{
    int count=0;
    for (int i=0; i < numSamples; i += zoomRatio) {
        samples[count++] = [self maximumMagnitude:samples+i :zoomRatio];
    }
    return count;
}

+ (short)maximumMagnitude:(short *)samples :(int)numSamples
{
    short max = SHRT_MIN;
    for (int i=0; i < numSamples; i++) {
        if (samples[i] > max)
            max = samples[i];
    }
    return max;
}

- (void) receiveSamples:(id)sender :(short *)samples :(int)numSamples
{
    
    [buffer appendBytes:samples length:numSamples*sizeof(short)];
    
    
    if ([buffer length] >= kLinearAnalyzerSamplesPerRipple*sizeof(short)) {
        short *bufferSamples = (short*)[buffer bytes];
        int bufferSampleSize = [buffer length] / sizeof(short);
        
        //reduce sample array in place
        int newSampleCount = [LinearAnalyzer reduceSamples:bufferSamples
                                                          :bufferSampleSize
                                                          :kLinearAnalyzerZoomRatio];

        //build waveform path
        NSRect bounds = [self bounds];
        wavePath = [[NSBezierPath alloc] init];
        [wavePath setLineWidth:3.0];
        [wavePath moveToPoint:NSMakePoint(0,bounds.size.height/2)];
        
        double step = bounds.size.width/newSampleCount;
        int i;
        for (i=0; i < newSampleCount; i++) {
            short sample = bufferSamples[i];
            float r = (float)(sample - SHRT_MIN)/(float)(SHRT_MAX-SHRT_MIN);
            float y = r * (float)bounds.size.height;
            [wavePath lineToPoint:NSMakePoint(i*step,y)];
        }
        
        //preserve any samples over kSampleRate in sampleBuffer
        long leftover = [buffer length] - kLinearAnalyzerSamplesPerRipple*sizeof(short);
        if (leftover > 0) {
            [buffer replaceBytesInRange:NSMakeRange(0,leftover)
                              withBytes:[buffer bytes]+kLinearAnalyzerSamplesPerRipple*sizeof(short)];
            [buffer setLength:leftover];
        } else {
            [buffer setLength:0];
        }
        
        //redraw
        [self setNeedsDisplay:true];
    }

    
    
    
//    [buffer replaceBytesInRange:NSMakeRange(0,numSamples*sizeof(short)) withBytes:samples];
//    samplesInBuffer = numSamples;
}

- (void)shedRipple
{
    
}

@end
