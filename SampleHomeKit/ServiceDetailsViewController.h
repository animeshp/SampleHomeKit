//
//  ServiceDetailsViewController.h
//  SampleHomeKit
//
//  Created by Porwal, Animesh on 7/3/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface ServiceDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) HMService *selectedService;
@property (weak, nonatomic) IBOutlet UITableView *charactersticsTableView;

@end
