//
//  MidiParser.m
//  leapsynth
//
//  Created by Wiggins on 10/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MidiParser.h"

@implementation MidiParser
@synthesize delegate;

- (id) init
{
    if (self) {
    }
    return self;
}

- (int) feedPacketData:(UInt8 *)bytes :(int)num_bytes
{
    int read;
    
    for (read=1; read < num_bytes; read++) {
        unsigned char b = bytes[0];
        
        if (b & 0x30) { 
            // status message
            unsigned char high = (b & 0xF0);
            unsigned char low = (b & 0x0F);
            
            switch (high) {
                case 0x80: {
                    UInt8 noteNumber = bytes[read++];
                    UInt8 velocity = bytes[read++];
                    [self noteOff:noteNumber withVelocity:velocity onChannel:low];
                    break;
                }
                case 0x90: {
                    UInt8 noteNumber = bytes[read++];
                    UInt8 velocity = bytes[read++];
                    if (velocity == 0) {
                        [self noteOff:noteNumber withVelocity:velocity onChannel:low];
                    } else {
                        [self noteOn:noteNumber withVelocity:velocity onChannel:low];
                    }
                    break;
                }
                case 0xB0: {
                    UInt8 controller = bytes[read++];
                    UInt8 value = bytes[read++];
                    [self controllerMessage:controller withValue:value onChannel:low];
                    break;
                }
                case 0xF0: {
                    if (low == 0) {
                        // skip system exclusive  "sysex" messages
                    }
                    else {
                        // 0xF0 .. 0xF7 - system common messages
                        // 0xF8 .. 0xFF - system realtime messages
                        [self systemMessage:b];
                    }
                    break;
                }
                
                default: {
                    //fall through and skip this message
                }
            }

        } else {
            //skip  data we dont care about
        }
    }
    return read;
}

- (void)systemMessage:(unsigned char)message
{
    if ([delegate respondsToSelector:@selector(systemMessage:)]) {
        [delegate systemMessage:message];
    }
}
- (void)controllerMessage:(UInt8)controller withValue:(UInt8)value onChannel:(UInt8)channel
{
    if ([delegate respondsToSelector:@selector(controllerMessage:withValue:onChannel:)]) {
        [delegate controllerMessage:controller withValue:value onChannel:channel];
    }

}
- (void)noteOn:(UInt8)noteNumber withVelocity:(UInt8)velocity onChannel:(UInt8)channel
{
    if ([delegate respondsToSelector:@selector(noteOn:withVelocity:onChannel:)]) {
        [delegate noteOn:noteNumber withVelocity:velocity onChannel:channel];
    }

}
- (void)noteOff:(UInt8)noteNumber withVelocity:(UInt8)velocity onChannel:(UInt8)channel
{
    if ([delegate respondsToSelector:@selector(noteOff:withVelocity:onChannel:)]) {
        [delegate noteOff:noteNumber withVelocity:velocity onChannel:channel];
    }

}

+ (double)frequencyFromNoteNumber:(UInt8)noteNumber
{
    double offset = (noteNumber - kReferenceNoteNumber) / (double) kNotesPerOctave;
    return kReferenceNoteFrequency * pow(2.0, offset);

}


@end