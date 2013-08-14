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
    
    [leapController enableGesture:LEAP_GESTURE_TYPE_KEY_TAP enable:YES];
    [leapController enableGesture:LEAP_GESTURE_TYPE_SCREEN_TAP enable:YES];
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

    
    NSArray *gestures = [frame gestures:nil];
    double now = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < [gestures count]; i++) {
        LeapGesture *gesture = [gestures objectAtIndex:i];
        for (LeapHand *hand in [gesture hands]) {
            int32_t hand_id = [hand id];
            LeapVector *pos = [hand palmPosition];

            if (hand_id != leftHandId && hand_id != rightHandId) {
                if ([pos x] < 0) {
                    leftHandId = hand_id;
                    leftFound = true;
                } else {
                    rightHandId = hand_id;
                    rightFound = true;
                }
            }
            if (hand_id == leftHandId && (now-leftTapDebounce)>kDebounceTimeInSecs ) {
                leftTapDebounce = now;
                if ([delegate respondsToSelector:@selector(leftHandTap::)]) {
                    [delegate leftHandTap:hand :gesture];
                }
                
            }
            else if (hand_id == rightHandId && (now-rightTapDebounce)>kDebounceTimeInSecs) {
                rightTapDebounce = now;
                if ([delegate respondsToSelector:@selector(rightHandTap::)]) {
                    [delegate rightHandTap:hand :gesture];
                }
            }

        }

    }
}


@end
