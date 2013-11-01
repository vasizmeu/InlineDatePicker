//
//  VCPerson.m
//  InlineDatePicker
//
//  Created by Vasilica Costescu on 29/10/2013.
//  Copyright (c) 2013 Vasi. All rights reserved.
//

#import "VCPerson.h"

@implementation VCPerson

- (id)initWithName:(NSString *)name dateOfBirth:(NSDate *)dateOfBirth placeOfBirth:(NSString *)placeOfBirth {
    
    if (self = [super init]){
        
        _name = [name copy];
        _dateOfBirth = dateOfBirth;
        _placeOfBirth = [placeOfBirth copy];
        
    }
    
    return self;
}

@end
