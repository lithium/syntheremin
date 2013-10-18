//
//  CSMultiSwitch.m
//  leapsynth
//
//  Created by Wiggins on 10/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSMultiSwitch.h"

@implementation CSMultiSwitch
@synthesize parameter;

- (double)doubleValue
{
    return [self selectedSegment];
}

@end
