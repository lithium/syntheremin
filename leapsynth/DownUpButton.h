//
//  DownUpButton.h
//  leapsynth
//
//  Created by Wiggins on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DownUpButtonDelegate <NSObject>
    - (void)mouseDown:(NSEvent *)evt :(int)tag;
    - (void)mouseUp:(NSEvent *)evt :(int)tag;
@end


@interface DownUpButton : NSButton  

@property (weak) id <DownUpButtonDelegate> delegate;


@end
