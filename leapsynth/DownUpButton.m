//
//  DownUpButton.m
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "DownUpButton.h"

@implementation DownUpButton

@synthesize delegate;


- (void)mouseDown:(NSEvent *)theEvent
{
    int tag = [self tag];
    
    if ([delegate respondsToSelector:@selector(mouseDown::)]) {
        [delegate mouseDown:theEvent :tag];
    }
    
    [super mouseDown:theEvent];

    if ([delegate respondsToSelector:@selector(mouseUp::)]) {
        [delegate mouseUp:theEvent :tag];
    }

}

@end
