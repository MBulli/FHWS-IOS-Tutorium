//
//  MBElement.h
//  PeriodicTable
//
//  Created by Markus on 05.05.14.
//  Copyright (c) 2014 MBulli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBElement : NSObject

@property(nonatomic, strong, readonly) NSString *name;
@property(nonatomic, strong, readonly) NSString *symbol;

@property(nonatomic, strong, readonly) NSNumber *period;
@property(nonatomic, strong, readonly) NSNumber *group;

@property(nonatomic, strong, readonly) NSString *state;
@property(nonatomic, strong, readonly) NSNumber *atomicNumber;
@property(nonatomic, strong, readonly) NSNumber *atomicWeight;
@property(nonatomic, strong, readonly) NSString *discoveryYear;

-(id)initWithDictionary:(NSDictionary*)dictionary;

-(NSComparisonResult)compareByAtomicNumber:(MBElement*)objB;

@end
