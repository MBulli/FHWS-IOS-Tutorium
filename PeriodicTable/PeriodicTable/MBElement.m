//
//  MBElement.m
//  PeriodicTable
//
//  Created by Markus on 05.05.14.
//  Copyright (c) 2014 MBulli. All rights reserved.
//

#import "MBElement.h"

@implementation MBElement

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    NSParameterAssert(dictionary);
    
    self = [self init];
    if (self) {
        _name = dictionary[@"name"];
        _symbol = dictionary[@"symbol"];
        _period = dictionary[@"period"];
        _group = dictionary[@"group"];
        _state = dictionary[@"state"];
        _atomicNumber = dictionary[@"atomicNumber"];
        _atomicWeight = dictionary[@"atomicWeight"];
        _discoveryYear = dictionary[@"discoveryYear"];
    }
    return self;
}

-(NSComparisonResult)compareByAtomicNumber:(MBElement *)objB
{
    if (self.atomicNumber.intValue == objB.atomicNumber.intValue) {
        return NSOrderedSame;
    } else if(self.atomicNumber.intValue > objB.atomicNumber.intValue) {
        return NSOrderedDescending;
    } else {
        return NSOrderedAscending;
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<MBElement %p: %@ %@ (%@)>",
            self, self.atomicNumber, self.name, self.symbol];
}

@end
