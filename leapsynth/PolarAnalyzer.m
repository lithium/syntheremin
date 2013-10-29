//
//  PolarAnalyzer.m
//  leapsynth
//
//  Created by Wiggins on 10/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PolarAnalyzer.h"

@implementation Waveform
@synthesize minRadius;

- (id)initWithBounds:(NSRect)frame
{
    if (self)
    {
        buffer = [[NSMutableData alloc] initWithCapacity:kNumSamplesPerRipple/kZoomRatio*sizeof(short)];
        [self setBounds:frame];
        minRadius = 5;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone 
{
    Waveform *newWaveform = [Waveform allocWithZone:zone];
    @synchronized (buffer) {
        newWaveform->buffer = [buffer copyWithZone:zone];
    }
    newWaveform->samplesInBuffer = samplesInBuffer;
    newWaveform->minRadius = minRadius;
    newWaveform->maxRadius = maxRadius;
    newWaveform->bounds = bounds;
    newWaveform->frequency = frequency;
    return newWaveform;
}


- (NSRect)bounds { return bounds; }
- (void)setBounds:(NSRect)newBounds
{
    maxRadius = newBounds.size.height/3;
    bounds = newBounds;
}
- (NSBezierPath *)bezierPath
{
    NSBezierPath *path = [[NSBezierPath alloc] init];
    NSShadow *shadow = [[NSShadow alloc] init];
    
    
    [path setLineWidth:3.0];
    
    [shadow setShadowBlurRadius:10];
    [shadow setShadowOffset:NSMakeSize(0,0)];
    [shadow setShadowColor:[NSColor colorWithSRGBRed:255/255.0 green:160/255.0 blue:0/255.0 alpha:1.0]];
    
    
    
    long samplesPerPeriod = kSampleRate/frequency;
    int numSamples = samplesInBuffer - (samplesInBuffer % samplesPerPeriod);

    
    NSPoint center = NSMakePoint(bounds.size.width/2, bounds.size.height/2);
    
    @synchronized (buffer) {

        short *samples = (short*)[buffer bytes];
        
        double radsRange = 2*M_PI;
        double step = radsRange/numSamples;
        for (int i=0; i < numSamples; i++) {
            short sample = samples[i];
            double normal = (double)(sample-SHRT_MIN)/(double)(SHRT_MAX-SHRT_MIN);
            double phi = i*step;
            double r = baseRadius + normal*(maxRadius-minRadius)+minRadius;
            NSPoint point = NSMakePoint(center.x + r*cos(phi), center.y + r*sin(phi));
            if (i==0) {
                [path moveToPoint:point];
            } else {
                [path lineToPoint:point];
            }
        }
    }
    [path closePath];
    [shadow set];
    
    return path;
}



- (short)maximumMagnitude:(short *)samples :(int)numSamples
{
    short max = SHRT_MIN;
    for (int i=0; i < numSamples; i++) {
        if (samples[i] > max)
            max = samples[i];
    }
    return max;
}

-(void)reduceSamples:(short*)samples :(int)numSamples :(int)zoomRatio
{
    samplesInBuffer = numSamples / zoomRatio;
//    buffer = [buffer initWithCapacity:samplesInBuffer*sizeof(short)];
    
    @synchronized (buffer) {
    
        short *sampleBuffer = (short*)[buffer bytes];
        for (int i=0; i < numSamples; i += zoomRatio) {
            sampleBuffer[i/zoomRatio] = [self maximumMagnitude:samples+i :zoomRatio];
        }
        
    }
}

@end


@implementation PolarAnalyzer

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ripples = [[NSMutableArray alloc] initWithCapacity:1];
        [ripples addObject:[[Waveform alloc] initWithBounds:[self bounds]]];

        waveColor = [NSColor colorWithSRGBRed:255/255.0 green:160/255.0 blue:0/255.0 alpha:1.0];
        
        sampleBuffer = [[NSMutableData alloc] initWithCapacity:kSampleRate*sizeof(short)];

    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];

    @synchronized(ripples) {
        
    
        int i=0;
        for (Waveform *ripple in ripples) 
        {
            NSBezierPath *path = [ripple bezierPath];
            double alpha = 1.0 - (ripple->baseRadius+ripple->minRadius) / (ripple->bounds.size.width/4);
            [[waveColor colorWithAlphaComponent:alpha] set];
            [path stroke];
            if (i++ > 0) {
                ripple->baseRadius += 2+5*alpha;
            }
            
        }
        
    }
    
    [ctx restoreGraphicsState];

}

- (void) setFrameSize:(NSSize)newSize
{
    [super setFrameSize:newSize];
    
    NSRect bounds = NSMakeRect(0,0,newSize.width, newSize.height);
    for (Waveform *ripple in ripples)
    {
        [ripple setBounds:bounds];
    }
}


- (void) receiveSamples :(id)sender :(short *)samples :(int)numSamples
{
    double freq = [sender frequencyInHz];

//    if (freq == 0)
//        return;
    
    [sampleBuffer appendBytes:samples length:numSamples*sizeof(short)];
    
    
    if ([sampleBuffer length] >= kNumSamplesPerRipple*sizeof(short)) {
        Waveform *firstRipple = [ripples objectAtIndex:0];
        [firstRipple reduceSamples:samples :numSamples :kZoomRatio];
        firstRipple->frequency = [sender frequencyInHz];
        
        //preserve any samples over kSampleRate in sampleBuffer
        long leftover = [sampleBuffer length] - kNumSamplesPerRipple*sizeof(short);
        if (leftover > 0) {
            [sampleBuffer replaceBytesInRange:NSMakeRange(0,leftover)
                                    withBytes:[sampleBuffer bytes]+kNumSamplesPerRipple*sizeof(short)];
            [sampleBuffer setLength:leftover];
        }
        
        [self setNeedsDisplay:true];
    }
    
    
    
//    Waveform *firstRipple = [ripples objectAtIndex:0];
//    [firstRipple->buffer replaceBytesInRange:NSMakeRange(0,numSamples*sizeof(short)) withBytes:samples];
//    firstRipple->samplesInBuffer = numSamples;
//    firstRipple->frequency = [sender frequencyInHz];
//
//    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
//    if (now - lastRippleTime > kMaxSecondsBetweenRipples+arc4random_uniform(kRandSecondsBetweenShed)) {
//        [self shedRipple];
//    }

//    [self setNeedsDisplay:true];
}

- (void)shedRipple
{    
//    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
//    if (now - lastRippleTime < kMinSecondsBetweenRipples) {
//        return;
//    }
//    lastRippleTime = now;
//    @synchronized(ripples) {
//
//        Waveform *newRipple = [[ripples objectAtIndex:0] copy];
//        [ripples addObject:newRipple];
//        if ([ripples count] > kMaxRipples) {
//            [ripples removeObjectAtIndex:1];
//        }
//    }
}
@end
