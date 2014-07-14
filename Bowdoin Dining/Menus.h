//
//  Menus.h
//  Bowdoin Dining
//
//  Created by Ruben on 7/11/14.
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Menus : NSObject {

}
+ (NSMutableArray *)formatDate: (NSDate *) todayDate;
+ (NSData *)loadMenuForDay: (NSInteger) day Month: (NSInteger) month Year: (NSInteger) year Offset: (NSInteger) offset;
+ (NSMutableArray *)createMenuFromXML:(NSData *) xmlData ForMeal: (NSUInteger) mealId AtLocation: (NSUInteger) locationId withFilters: (NSMutableArray *) filters;

@end