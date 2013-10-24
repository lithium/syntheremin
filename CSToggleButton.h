//
//  CSToggleButton.h
//  leapsynth
//
//  Created by Wiggins on 10/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSControl.h"

@interface CSToggleButton : CSControl
{
    NSImage *onImage, *offImage;
    
@public
    BOOL toggled;
}

- (void)setButtonName:(NSString*)name;

- (BOOL)toggled;
- (void)setToggled:(BOOL)flag;

@end
