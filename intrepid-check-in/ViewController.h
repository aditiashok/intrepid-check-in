//
//  ViewController.h
//  intrepid-check-in
//
//  Created by Aditi Ashok on 6/16/15.
//  Copyright (c) 2015 Aditi Ashok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController <CLLocationManagerDelegate> {
    BOOL _didStartMonitoringRegion;
}
- (void) sendNotificiation;
- (void) messageSlack: (NSString *) message;


@end

