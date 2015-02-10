//
//  GraphitiProtocol.h
//  Graphiti
//
//  Created by Kevin Carbone on 8/16/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GraphitiProtocol <NSObject>

-(void)createPost:(UIImage*)image1 :(UIImage*)image2 :(NSString*)title;
@end
