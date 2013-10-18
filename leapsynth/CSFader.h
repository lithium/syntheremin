//
//  CSFader.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSControl.h"

@interface CSFader : CSControl
{
    NSImage *trackImage;
    NSImage *knobImage;
    
    BOOL dragging;
    double knobWidth,knobHeight;
}
@end
