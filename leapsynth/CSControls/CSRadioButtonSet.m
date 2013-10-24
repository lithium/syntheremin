//
//  CSRadioButtonSet.m
//  leapsynth
//
//  Created by Wiggins on 10/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CSRadioButtonSet.h"

@implementation CSRadioButtonSet

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        buttons = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setDoubleValue:(double)newValue
{
    int c = [buttons count];
    for (int i=0; i < c; i++) {
        CSToggleButton *button = [buttons objectAtIndex:i];    
        button->toggled = (i == newValue);
    }
    [super setDoubleValue:newValue];
}

- (void)setButtonNames:(NSString *)firstName
{
    double x = 0;
    int i=0;
    NSRect bounds = [self bounds];
    NSArray *names = [firstName componentsSeparatedByString:@","];
    double step = bounds.size.width / [names count];
    for (NSString *name in names) {
        NSRect frame = NSMakeRect(x, 0, step, bounds.size.height);
        CSToggleButton *button = [[CSToggleButton alloc] initWithFrame:frame];
        [button setButtonName:name];
        [button setTarget:self];
        [button setAction:@selector(buttonToggled:)];
        [button setTag:i];
        [buttons addObject:button];
        [self addSubview:button];
        x += step;
        i++;
    }
    
    [self setMinValue:0];
    [self setMaxValue:[buttons count]];
    [self setDoubleValue:0];
}

-(void)buttonToggled:(id)sender
{
    int senderTag = [sender tag];
    [self setDoubleValue:senderTag];
}
@end
