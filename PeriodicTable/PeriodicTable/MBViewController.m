//
//  MBViewController.m
//  PeriodicTable
//
//  Created by Markus on 05.05.14.
//  Copyright (c) 2014 MBulli. All rights reserved.
//

#import "MBViewController.h"

#import <CoreGraphics/CoreGraphics.h>

#import "MBElement.h"

@interface MBViewController ()

@property(nonatomic, strong) NSArray *elements;
@property(nonatomic, strong) NSCache *imageCache;


-(NSArray*)loadElementsFromJson;
-(UIImage*)imageForElement:(MBElement*)element forSize:(CGSize)size;
@end

@implementation MBViewController

- (void)viewDidLoad
{
    self.tableView.delegate = self;
    
    [super viewDidLoad];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = insets;
    self.tableView.contentInset = insets;
    
    self.imageCache = [[NSCache alloc] init];

    self.elements = [[self loadElementsFromJson] sortedArrayUsingSelector:@selector(compareByAtomicNumber:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)loadElementsFromJson
{
    NSError *error = nil;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"elements" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (!data) {
        NSLog(@"Failed to load json from '%@'", url);
        return nil;
    }
    
    id elements = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    if (!elements) {
        NSLog(@"Failed to parse json with error: %@", error);
        return nil;
    }
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[elements count]];
    
    for (NSDictionary *dict in elements) {
        MBElement *ele = [[MBElement alloc] initWithDictionary:dict];
        
        [result addObject:ele];
    }

    return result;
}

-(UIImage*)imageForElement:(MBElement*)element forSize:(CGSize)size;
{
    if (CGSizeEqualToSize([[self.imageCache objectForKey:element.atomicNumber] size], size)) {
        return [self.imageCache objectForKey:element.atomicNumber];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    NSString *text = element.symbol;
    UIFont *font = [UIFont boldSystemFontOfSize:24];
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    
    [[UIColor brownColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), bounds);
    
    [text drawInRect:bounds withAttributes:@{ NSFontAttributeName: font,
                                              NSForegroundColorAttributeName: [UIColor whiteColor] }];
    
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.imageCache setObject:img forKey:element.atomicNumber];
    return img;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.elements.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"elementCell"
                                                            forIndexPath:indexPath];
    
    MBElement *element = [self.elements objectAtIndex:indexPath.row];
    
    // config cell
    cell.textLabel.text = [NSString stringWithFormat:@"%d - %@ (%@)",
                           element.atomicNumber.intValue, element.name, element.symbol];
    
    CGSize imgSize = CGSizeMake(cell.frame.size.height, cell.frame.size.height);
    cell.imageView.image = [self imageForElement:element forSize:imgSize];
    
    return cell;
}


@end
