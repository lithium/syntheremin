//
//  TutorialBox.h
//  leapsynth
//
//  Created by Wiggins on 11/1/13.
//
//

#import <Cocoa/Cocoa.h>

@protocol TutorialDelegate <NSObject>

-(void)tutorialComplete;

@end

@interface TutorialBox : NSBox

@property (weak) id  <TutorialDelegate> delegate;
@property int tutorialStep;
@property (weak) IBOutlet NSTextField *tutorialText;
@property (weak) IBOutlet NSImageView *backgroundImage;

- (void)nextStep;
@end
