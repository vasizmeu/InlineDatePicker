//
//  VCPeopleViewController.m
//  InlineDatePicker
//
//  Created by Vasilica Costescu on 29/10/2013.
//  Copyright (c) 2013 Vasi. All rights reserved.
//

#import "VCPeopleViewController.h"
#import "VCPerson.h"

#define kDatePickerTag 1

static NSString *kPersonCellID = @"personCell";
static NSString *kDatePickerCellID = @"datePickerCell";
static NSString *kSegueIdentifier = @"addPerson";

@interface VCPeopleViewController ()

@property (strong, nonatomic) NSMutableArray *persons;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;

- (IBAction)dateChanged:(UIDatePicker *)sender;

@end

@implementation VCPeopleViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    
    [self createDateFormatter];
    
    [self createFakeData];
}

#pragma mark - Helper methods

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
}

- (void)createFakeData {
    
    VCPerson *p1 = [[VCPerson alloc] initWithName:@"John Smith"
                                      dateOfBirth:[NSDate dateWithTimeIntervalSince1970:632448000]
                                     placeOfBirth:@"London"];
    
    
    VCPerson *p2 = [[VCPerson alloc] initWithName:@"Jane Andersen"
                                      dateOfBirth:[NSDate dateWithTimeIntervalSince1970:123456789]
                                     placeOfBirth:@"San Francisco"];
    
    if (!self.persons){
        
        self.persons = [[NSMutableArray alloc] init];
        
    }
    
    [self.persons addObject:p1];
    [self.persons addObject:p2];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (BOOL)datePickerIsShown {
    
    return self.datePickerIndexPath != nil;
}

- (UITableViewCell *)createPersonCell:(VCPerson *)person {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPersonCellID];
    
    cell.textLabel.text = person.name;
    
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:person.dateOfBirth];
    
    return cell;
    
}

- (UITableViewCell *)createPickerCell:(NSDate *)date {

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];

    UIDatePicker *targetedDatePicker = (UIDatePicker *)[cell viewWithTag:kDatePickerTag];

    [targetedDatePicker setDate:date animated:NO];
    
    return cell;
}


- (void)hideExistingPicker {
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                             withRowAnimation:UITableViewRowAnimationFade];
    
    self.datePickerIndexPath = nil;
}


- (NSIndexPath *)calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath {
    
    NSIndexPath *newIndexPath;
    
    if (([self datePickerIsShown]) && (self.datePickerIndexPath.row < selectedIndexPath.row)){
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row - 1 inSection:0];
        
    }else {
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row  inSection:0];
        
    }
    
    return newIndexPath;
}

- (void)showNewPickerAtIndex:(NSIndexPath *)indexPath {    
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = self.tableView.rowHeight;
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)){
        
        rowHeight = self.pickerCellRowHeight;
        
    }
    
    return rowHeight;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = [self.persons count];

    if ([self datePickerIsShown]){
        
        numberOfRows++;
        
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)){
        
        VCPerson *person = self.persons[indexPath.row -1];
        
        cell = [self createPickerCell:person.dateOfBirth];
        
    }else {
        
        VCPerson *person = self.persons[indexPath.row];
        
        cell = [self createPersonCell:person];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.tableView beginUpdates];
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row - 1 == indexPath.row)){
        
        [self hideExistingPicker];
        
    }else {
        
        NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker:indexPath];
        
        if ([self datePickerIsShown]){
            
            [self hideExistingPicker];
        
        }
        
        [self showNewPickerAtIndex:newPickerIndexPath];
        
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:0];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
}

#pragma mark - Action method

- (IBAction)dateChanged:(UIDatePicker *)sender {
    
    NSIndexPath *parentCellIndexPath = nil;
    
    if ([self datePickerIsShown]){
        
        parentCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
        
    }else {
        
        return;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:parentCellIndexPath];
    VCPerson *person = self.persons[parentCellIndexPath.row];
    person.dateOfBirth = sender.date;
    
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:sender.date];
}

#pragma mark - VCAddPersonDelegate methods

- (void)savePersonDetails:(VCPerson *)person {
    
    [self.persons addObject:person];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:[self.persons count]-1 inSection:0]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:kSegueIdentifier]){
        
        VCAddPersonTableViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        
        controller.delegate = self;
    }
}

@end
