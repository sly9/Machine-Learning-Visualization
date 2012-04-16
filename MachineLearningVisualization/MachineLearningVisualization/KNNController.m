//
//  KNNController.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 3/27/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "KNNController.h"
#import "KNNAlgorithm.h"
#import "KNN.h"
#import "MLDataPoint.h"
@implementation KNNController 

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        knnAlgorithm = [[KNNAlgorithm alloc] init]; 
        knn = [[KNN alloc] init];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder:aDecoder]) {
        knnAlgorithm = [[KNNAlgorithm alloc] init];         
        knn = [[KNN alloc] init];
    }
    return self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)test:(id)sender {
    MLDataPoint *p = [[MLDataPoint alloc] initWithX:100 Y:100 andLabel:0];
    MLDataPoint *p1 = [[MLDataPoint alloc] initWithX:500 Y:500 andLabel:1];
    MLDataPoint *p2 = [[MLDataPoint alloc] initWithX:100 Y:200 andLabel:0];
    MLDataPoint *p3 = [[MLDataPoint alloc] initWithX:200 Y:100 andLabel:0];
    MLDataPoint *p4 = [[MLDataPoint alloc] initWithX:500 Y:100 andLabel:0];
    MLDataPoint *p5 = [[MLDataPoint alloc] initWithX:300 Y:400 andLabel:1];
    MLDataPoint *p6 = [[MLDataPoint alloc] initWithX:400 Y:100 andLabel:1];
    NSArray *training = [NSArray arrayWithObjects:p,p1,p2,p3,p4,p5,p6, nil];
    
    NSMutableArray *testing = [[NSMutableArray alloc] init];
    for (int i=0; i<600; i+=10) {
        for (int j=0; j<600; j+=10) {
            p = [[MLDataPoint alloc] initWithX:i Y:j andLabel:0];
            [testing addObject:p];
        }
    }
    
    //knnAlgorithm classify:<#(NSData *)#> withPoints:<#(NSData *)#>
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
