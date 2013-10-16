//
//  CSFader.h
//  leapsynth
//
//  Created by Wiggins on 10/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSSlider.h"

@interface CSFader : CSSlider
{
    NSImage *trackImage;
    NSImage *knobImage;
    
    BOOL dragging;
    double knobWidth,knobHeight;
}
@end
