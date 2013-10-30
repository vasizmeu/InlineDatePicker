//
//  VCPerson.h
//  InlineDatePicker
//
//  Created by Vasilica Costescu on 29/10/2013.
//  Copyright (c) 2013 Vasi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCPerson : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (copy, nonatomic) NSString *placeOfBirth;

- (id)initWithName:(NSString *)name dateOfBirth:(NSDate *)dateOfBirth placeOfBirth:(NSString *)placeOfBirth;

@end
