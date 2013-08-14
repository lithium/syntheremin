//
//  LeapSyntheremin.m
//  leapsynth
//
//  Created by Wiggins on 8/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LeapSyntheremin.h"

@implementation LeapSyntheremin

@synthesize delegate;



- (id)init
{
    leftHandId = rightHandId = -1;
    
    leapController = [[LeapController alloc] init];
    [leapController addListener:self];
    
    return self;
}


- (void)onFrame:(NSNotification *)notification
{
    LeapController *leap = (LeapController *)[notification object];
    LeapFrame *frame = [leap frame:0];
    bool leftFound,rightFound;
    
    leftFound = rightFound = false;
    
    if ([[frame hands] count] != 0) {
        for (LeapHand *hand in [frame hands]) {
            int32_t hand_id = [hand id];
            LeapVector *pos = [hand palmPosition];
          
            if (hand_id != leftHandId && hand_id != rightHandId) {
                //unknown hand assign it.
                if ([pos x] < 0) {
                    leftHandId = hand_id;
                    leftFound = true;
                } else {
                    rightHandId = hand_id;
                    rightFound = true;
                }
            }
            
            if (hand_id == leftHandId) {
                if ([delegate respondsToSelector:@selector(leftHandMotion::)]) {
                    [delegate leftHandMotion:hand :pos];
                }

            }
            else if (hand_id == rightHandId) {
                if ([delegate respondsToSelector:@selector(rightHandMotion::)]) {
                    [delegate rightHandMotion:hand :pos];
                }
            }
        }
    }
    
//    if (leftHandId != -1 && !leftFound) {
//        if ([delegate respondsToSelector:@selector(leftHandGone:)]) {
//            [delegate leftHandGone:leftHandId];
//        }
//        leftHandId = -1;
//    }
//    if (rightHandId != -1 && !rightFound) {
//        if ([delegate respondsToSelector:@selector(rightHandGone:)]) {
//            [delegate rightHandGone:rightHandId];
//        }
//        rightHandId = -1;
//    }

    
//    NSLog(@"Frame id: %lld, timestamp: %lld, hands: %ld, fingers: %ld, tools: %ld, gestures: %ld",
//          [frame id], [frame timestamp], [[frame hands] count],
//          [[frame fingers] count], [[frame tools] count], [[frame gestures:nil] count]);

}

@end