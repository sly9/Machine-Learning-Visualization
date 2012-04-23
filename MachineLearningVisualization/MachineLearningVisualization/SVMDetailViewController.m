//
//  MLDetailViewController.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/22/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "SVMDetailViewController.h"
#import "SVMLight.h"

@interface SVMDetailViewController (){
    SVMLight *light;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation SVMDetailViewController
@synthesize textfield = _textfield;
@synthesize label = _label;

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    //[self train];    
    //[self test];
    
}

- (void)viewDidUnload
{
    [self setTextfield:nil];
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
- (IBAction)trainData:(id)sender {
    light = [[SVMLight alloc] init];
    NSMutableArray *pos = [[NSMutableArray alloc] init];
    NSMutableArray *neg = [[NSMutableArray alloc] init];
    [pos addObject:@"1:100 2:100"];
    [pos addObject:@"1:101 2:99"];
    [neg addObject:@"1:10 2:10"];
    [neg addObject:@"1:11 2:9"];
    [light trainWithPositiveData:pos andNegativeData:neg];
    
}

- (IBAction)testData:(id)sender {
    NSArray *samples = [self.textfield.text componentsSeparatedByString:@"\n"];
    
    NSArray *result = [light testSample:samples];
    NSLog(@"tested result: %@",result.description);
    self.label.text = result.description;
}
@end
