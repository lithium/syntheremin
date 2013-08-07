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

@end

@interface LeapSyntheremin : NSObject<LeapListener>
{
    LeapController *leapController;

    int32_t leftHandId;
    int32_t rightHandId;
}

@property (weak) id <LeapSynthereminDelegate> delegate;

- (id)init;


@end
