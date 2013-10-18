//
//  CSPopupButton.m
//  leapsynth
//
//  Created by Wiggins on 10/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSPopupButton.h"

@implementation CSPopupButton
@synthesize parameter;

- (double)doubleValue
{
    return [self selectedTag];
}

- (void)setDoubleValue:(double)aDouble
{
    [self selectItemWithTag:aDouble];
}

@end
