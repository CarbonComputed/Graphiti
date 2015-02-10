//
//  GraphitiGLViewController.m
//  Graphiti
//
//  Created by Kevin Carbone on 8/3/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

#import "GraphitiGLViewController.h"
#import "CameraScene.h"



@interface GraphitiGLViewController ()
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation GraphitiGLViewController

-(id)initWithView:(GLKView*)view{
    self = [super init];
    if (self) {
        self.view = view;
        [self viewDidLoad];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//
//- (id)init {
//    if ((self = [super init])) {
//
//    }
//    return self;
//}

-(void)viewDidLoad{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    //self.delegate = self;
    GLKView* view = (GLKView*)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    float aspect = fabsf(self.view.bounds.size.width/self.view.bounds.size.height );
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(61.4f), aspect, 0.1f, 10000.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    self.scene = [[CameraScene alloc] initWithEffect:self.effect];
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:^ (CMDeviceMotion *motionData, NSError *error) {
        CMRotationMatrix r = motionData.attitude.rotationMatrix;
        _currentPitch = motionData.attitude.pitch;
        _currentRoll = motionData.attitude.roll;
        _currentYaw = motionData.attitude.yaw;
        
        GLKMatrix4 baseModelViewMatrix;
        //        baseModelViewMatrix = GLKMatrix4Make(r.m11, r.m21, r.m31, 0.0f,
        //                                             r.m13, r.m23, r.m33, 0.0f,
        //                                             -r.m12, -r.m22, -r.m32, 0.0f,
        //                                             0.0f,  0.0f,  0.0f,  1.0f);
        baseModelViewMatrix = GLKMatrix4Make(r.m11, r.m21, r.m31, 0.0f,
                                             r.m12, r.m22, r.m32, 0.0f,
                                             r.m13, r.m23, r.m33, 0.0f,
                                             0.0f,  0.0f,  0.0f,  1.0f);
        
        _scene.rotationMatrix = baseModelViewMatrix;
        CMAcceleration gravity = motionData.gravity;
        CMAcceleration userAcceleration = motionData.userAcceleration;
        CMRotationRate rotate = motionData.rotationRate;
        CMCalibratedMagneticField field = motionData.magneticField;
        
    }];
    

}



//


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    [self.scene renderWithModelViewMatrix:GLKMatrix4Identity];
    glDisable(GL_BLEND);

}

- (void)update {
    
    [self.scene update:self.timeSinceLastUpdate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
