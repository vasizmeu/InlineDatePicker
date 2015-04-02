//
//  VCDetailsTableViewController.m
//  InlineDatePicker
//
//  Created by Vasilica Costescu on 24/10/2013.
//  Copyright (c) 2013 Vasi. All rights reserved.
//

#import "VCAddPersonTableViewController.h"
#import "VCPerson.h"

#define kDatePickerIndex 2
#define kDatePickerCellHeight 164

@interface VCAddPersonTableViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (assign) BOOL datePickerIsShowing;

@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *placeOfBirthTextField;

@property (strong, nonatomic) NSDate *selectedBirthday;

@property (strong, nonatomic) UITextField *activeTextField;

@end

@implementation VCAddPersonTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupBirthdayLabel];
    
    [self signUpForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper methods

- (void)setupBirthdayLabel {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *defaultDate = [NSDate date];
    
    self.birthdayLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.birthdayLabel.textColor = [self.tableView tintColor];
    
    self.selectedBirthday = defaultDate;
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow {
    
    if (self.datePickerIsShowing){
        
        [self hideDatePickerCell];
    }
}

#pragma mark - Table view methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == kDatePickerIndex && self.datePickerIsShowing == NO){
        //hide date picker
        return 0.0f;
        
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1){
        
        if (self.datePickerIsShowing){
            
            [self hideDatePickerCell];
            
        }else {
            
            [self.activeTextField resignFirstResponder];
            
            [self showDatePickerCell];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.datePicker.hidden = NO;
    self.datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.datePicker.alpha = 1.0f;
    
    }];
}

- (void)hideDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePicker.alpha = 0.0f;
    }
                     completion:^(BOOL finished){
                         self.datePicker.hidden = YES;
                     }];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
    
}

#pragma mark - Action methods

- (IBAction)pickerDateChanged:(UIDatePicker *)sender {

    self.birthdayLabel.text =  [self.dateFormatter stringFromDate:sender.date];

    self.selectedBirthday = sender.date;
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    
    VCPerson *person = [[VCPerson alloc] initWithName:self.nameTextField.text
                                          dateOfBirth:self.selectedBirthday
                                         placeOfBirth:self.placeOfBirthTextField.text];
    
    [self.delegate savePersonDetails:person];
    
    [self dismissViewControllerAnimated:YES completion:NULL];    
}


@end
