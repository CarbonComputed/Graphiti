//
//  Post.m
//  Graphiti
//
//  Created by Kevin Carbone on 8/16/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "Post.h"

@implementation Post
- (id)initWithDictionary:(NSDictionary*)data{

    if ((self = [super init])) {

        _attributes = data;
        _id = data[@"_id"];
        _owner = data[@"owner"];
        _title = data[@"title"];
        _latitude = [data[@"lat"] doubleValue];
        _longitude = [data[@"lon"] doubleValue];
        _roll = [data[@"roll"] doubleValue];
        _pitch = [data[@"pitch"] doubleValue];
        _yaw = [data[@"yaw"] doubleValue];
        _score = [data[@"rank"] doubleValue];
        _upvotes = [data[@"upvotes"] doubleValue];
        _downvotes = [data[@"downvotes"] doubleValue];
        _direction = [data[@"direction"] intValue];
        _image1Id = data[@"image1"];
        _image2Id = data[@"image2"];

        
    }
    return self;
}
@end
