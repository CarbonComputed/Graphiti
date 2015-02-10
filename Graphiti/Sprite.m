//
//  SGGSprite.m
//  SimpleGLKitGame
//
//  Created by Ray Wenderlich on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sprite.h"

typedef struct {
    GLKVector2 geometryVertex;
    GLKVector2 textureVertex;
} TexturedVertex;

typedef struct {
    TexturedVertex bl;
    TexturedVertex br;    
    TexturedVertex tl;
    TexturedVertex tr;    
} TexturedQuad;

@interface Sprite()

@property (strong) GLKBaseEffect * effect;
@property (assign) TexturedQuad quad;
@property (strong) GLKTextureInfo * textureInfo;

@end

@implementation Sprite
@synthesize effect = _effect;
@synthesize quad = _quad;
@synthesize textureInfo = _textureInfo;

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect {
    if ((self = [super init])) {
        self.effect = effect;
        
        NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES],
                                  GLKTextureLoaderOriginBottomLeft, 
                                  nil];
        
        NSError * error;    
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        
        self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        if (self.textureInfo == nil) {
            NSLog(@"Error loading file: %@", [error localizedDescription]);
            return nil;
        }
        
        self.contentSize = CGSizeMake(self.textureInfo.width, self.textureInfo.height);
                
        TexturedQuad newQuad;
        newQuad.bl.geometryVertex = GLKVector2Make(0, 0);
        newQuad.br.geometryVertex = GLKVector2Make(self.textureInfo.width, 0);
        newQuad.tl.geometryVertex = GLKVector2Make(0, self.textureInfo.height);
        newQuad.tr.geometryVertex = GLKVector2Make(self.textureInfo.width, self.textureInfo.height);

        newQuad.bl.textureVertex = GLKVector2Make(0, 0);
        newQuad.br.textureVertex = GLKVector2Make(1, 0);
        newQuad.tl.textureVertex = GLKVector2Make(0, 1);
        newQuad.tr.textureVertex = GLKVector2Make(1, 1);
        self.quad = newQuad;

    }
    return self;
}


- (id)initWithUIImage:(UIImage *)image effect:(GLKBaseEffect *)effect {
    if ((self = [super init])) {
        self.effect = effect;
        
        NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES],
                                  GLKTextureLoaderOriginBottomLeft,
                                  nil];
        
        NSError *error;
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
        UIImage* image2 = [UIImage imageWithData:UIImagePNGRepresentation([UIImage imageWithCGImage:imageRef])];
        
        self.textureInfo = [GLKTextureLoader textureWithCGImage:image2.CGImage options:nil error:&error];
        NSLog(self.textureInfo.description);
        if (self.textureInfo == nil) {
            NSLog(@"Error loading file: %@", [error localizedDescription]);
            return nil;
        }
        
        self.contentSize = CGSizeMake(self.textureInfo.width, self.textureInfo.height);
        
        TexturedQuad newQuad;
        newQuad.bl.geometryVertex = GLKVector2Make(0, 0);
        newQuad.br.geometryVertex = GLKVector2Make(self.textureInfo.width, 0);
        newQuad.tl.geometryVertex = GLKVector2Make(0, self.textureInfo.height);
        newQuad.tr.geometryVertex = GLKVector2Make(self.textureInfo.width, self.textureInfo.height);
        
        newQuad.bl.textureVertex = GLKVector2Make(0, 0);
        newQuad.br.textureVertex = GLKVector2Make(1, 0);
        newQuad.tl.textureVertex = GLKVector2Make(0, 1);
        newQuad.tr.textureVertex = GLKVector2Make(1, 1);
        self.quad = newQuad;
        
    }
    return self;
}



- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix { 
        
    [super renderWithModelViewMatrix:modelViewMatrix];
    
    self.effect.texture2d0.name = self.textureInfo.name;
    self.effect.texture2d0.enabled = YES;
    self.effect.transform.modelviewMatrix = GLKMatrix4Multiply(modelViewMatrix, [self modelMatrix:YES]);
    
    [self.effect prepareToDraw];
       
    long offset = (long)&_quad;
       
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    int size = sizeof(TexturedVertex);
        
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, textureVertex)));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
}

@end
