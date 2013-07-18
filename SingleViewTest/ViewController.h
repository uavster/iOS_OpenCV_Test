//
//  ViewController.h
//  SingleViewTest
//
//  Created by uavster on 6/10/13.
//  Copyright (c) 2013 uavster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>

@interface ViewController : UIViewController<CvVideoCameraDelegate> {
cv::CascadeClassifier faceCascade;
}

-(IBAction)startCapturePressed:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton *startCaptureButton;
@property (nonatomic, strong) IBOutlet UIImageView *videoView;

@end
