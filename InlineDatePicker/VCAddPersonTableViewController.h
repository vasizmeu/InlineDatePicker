//
//  VCDetailsTableViewController.h
//  InlineDatePicker
//
//  Created by Vasilica Costescu on 24/10/2013.
//  Copyright (c) 2013 Vasi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VCPerson;

@protocol VCAddPersonDelegate <NSObject>

- (void)savePersonDetails:(VCPerson *)person;

@end

@interface VCAddPersonTableViewController : UITableViewController <UITextFieldDelegate>

@property  (weak, nonatomic) id<VCAddPersonDelegate> delegate;

- (IBAction)pickerDateChanged:(UIDatePicker *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;
- (IBAction)savePressed:(UIBarButtonItem *)sender;

@end
