//
//  MidiParser.h
//  leapsynth
//
//  Created by Wiggins on 10/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kReferenceNoteNumber 69
#define kReferenceNoteFrequency 440
#define kNotesPerOctave 12

@interface MidiParser : NSObject
{
    id delegate;
}
@property id delegate;

- (id) init;
- (int) feedPacketData:(UInt8 *)bytes :(int)num_bytes;


- (void)systemMessage:(unsigned char)message;
- (void)controllerMessage:(UInt8)controller withValue:(UInt8)value onChannel:(UInt8)channel;
- (void)noteOn:(UInt8)noteNumber withVelocity:(UInt8)velocity onChannel:(UInt8)channel;
- (void)noteOff:(UInt8)noteNumber withVelocity:(UInt8)velocity onChannel:(UInt8)channel;

+ (double)frequencyFromNoteNumber:(UInt8)noteNumber;
@end
