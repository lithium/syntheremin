//
//  CSRadioButtonSet.h
//  leapsynth
//
//  Created by Wiggins on 10/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSControl.h"
#import "CSToggleButton.h"

@interface CSRadioButtonSet : CSControl
{
    NSMutableArray *buttons;
}

-(void)setButtonNames:(NSString*)names;
-(void)buttonToggled:(id)sender;

-(void)clearSelection;
@end
