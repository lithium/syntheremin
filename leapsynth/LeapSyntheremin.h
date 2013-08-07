//
//  LeapSyntheremin.h
//  leapsynth
//
//  Created by Wiggins on 8/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"

@interface LeapSyntheremin : NSObject<LeapListener>
{
    LeapController *leapController;

}

- (id)init;

@end
