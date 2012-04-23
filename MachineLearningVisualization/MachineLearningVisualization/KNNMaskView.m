//
//  KNNMaskView.m
//  MachineLearningVisualization
//
//  Created by Liuyi Sun on 4/16/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "KNNMaskView.h"
#import "MLAppDelegate.h"
@implementation KNNMaskView

- (id)init
{
    //MLAppDelegate *delegate = (MLAppDelegate *)[UIApplication sharedApplication].delegate;
    

    
    if (self = [super initWithFrame:CGRectMake(0, 0, 1024, 768)]) {
        // Initialization code
        UIImage *image = [UIImage imageNamed:@"mask.png"];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
        imageView.frame = self.frame;
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        
        [self addSubview:imageView];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:gestureRecognizer];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)tap
{
    [self removeFromSuperview];
}

@end
