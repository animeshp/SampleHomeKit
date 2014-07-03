//
//  AccessoryDetailViewController.h
//  SampleHomeKit
//
//  Created by Porwal, Animesh on 7/3/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface AccessoryDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, HMAccessoryDelegate>

@property (strong, nonatomic) HMAccessory *selectedAccessory;
@property (weak, nonatomic) IBOutlet UITableView *serviceTableView;

@end
