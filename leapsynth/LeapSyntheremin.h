//
//  LeapSyntheremin.h
//  leapsynth
//
//  Created by Wiggins on 8/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"

@protocol LeapSynthereminDelegate <NSObject>
    - (void)leftHandMotion:(LeapHand *)hand :(LeapVector *)position;
    - (void)rightHandMotion:(LeapHand *)hand :(LeapVector *)position;

    - (void)leftHandGone:(int32_t)hand_id;
    - (void)rightHandGone:(int32_t)hand_id;

- (void)leftHandTap:(LeapHand *)hand :(LeapGesture *)gesture;
- (void)rightHandTap:(LeapHand *)hand :(LeapGesture *)gesture;
@end

#define kDebounceTimeInSecs 0.250

@interface LeapSyntheremin : NSObject<LeapListener>
{
    LeapController *leapController;

    int32_t leftHandId;
    int32_t rightHandId;
    
    double leftTapDebounce;
    double rightTapDebounce;
}

@property (weak) id <LeapSynthereminDelegate> delegate;

- (id)init;


@end
