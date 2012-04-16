//
//  KNNSideController.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 4/15/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "KNNSideController.h"
#import <QuartzCore/QuartzCore.h>
@interface KNNSideController ()

@end

@implementation KNNSideController
@synthesize firstView;
@synthesize secondView;
@synthesize switchButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        classificationStatus = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.secondView.hidden = YES;
    self.firstView.hidden = NO;
    self.secondView.layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0);
    
}

- (void)viewDidUnload
{
    [self setSecondView:nil];
    [self setFirstView:nil];
    [self setSwitchButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)switchStatus:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.layer.transform = CATransform3DMakeRotation(M_PI_2,0.0,1.0,0.0); //flip halfway
    } completion:^(BOOL finished){
        self.secondView.hidden = classificationStatus;
        self.firstView.hidden = !classificationStatus;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0); //finish the flip
        } completion:^(BOOL finished){
            // Flip completion code here
            if (!classificationStatus) {
                self.firstView.layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0);
            }
            classificationStatus = !classificationStatus;
            if (classificationStatus) {
                self.switchButton.title = @"add data";
            } else {
                self.switchButton.title = @"classify";
            }
            
        }];
    }];
}

@end
