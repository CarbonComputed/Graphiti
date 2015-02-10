//
//  Post.h
//  Graphiti
//
//  Created by Kevin Carbone on 8/16/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sprite.h"

@interface Post : NSObject
@property NSDictionary* attributes;

@property NSString* id;
@property NSString* owner;
@property NSString* title;
@property double latitude;
@property double longitude;
@property double roll;
@property double pitch;
@property double yaw;
@property double score;
@property int upvotes;
@property int downvotes;
@property int direction;
@property NSDate* dateCreated;
@property NSDate* dateModified;
@property NSString* image1Id;
@property NSString* image2Id;

@property Sprite* sprite;
@property UIImage* image2;

- (id)initWithDictionary:(NSDictionary*)data;



@end
