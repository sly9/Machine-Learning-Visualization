//
//  SVMLight.h
//  SVMLight
//
//  Created by Liuyi Sun on 3/22/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVMLight : NSObject

-(void) trainWithPositiveData:(NSArray *)pos andNegativeData:(NSArray *)neg;
-(NSArray *) testSample:(NSArray *)samples;
@end
