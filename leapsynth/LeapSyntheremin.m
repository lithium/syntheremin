//
//  LeapSyntheremin.m
//  leapsynth
//
//  Created by Wiggins on 8/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LeapSyntheremin.h"

@implementation LeapSyntheremin



- (id)init
{
    leapController = [[LeapController alloc] init];
    [leapController addListener:self];
    return self;
}


- (void)onFrame:(NSNotification *)notification
{
    LeapController *leap = (LeapController *)[notification object];
    LeapFrame *frame = [leap frame:0];
    
    NSLog(@"Frame id: %lld, timestamp: %lld, hands: %ld, fingers: %ld, tools: %ld, gestures: %ld",
          [frame id], [frame timestamp], [[frame hands] count],
          [[frame fingers] count], [[frame tools] count], [[frame gestures:nil] count]);

}

@end
