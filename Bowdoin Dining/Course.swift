//
//  Course.swift
//  Bowdoin Dining
//
//  Created by Ruben on 7/18/14.
//
//

import Foundation

class Course : NSObject {
    var courseName  : NSString = ""
    var menuItems   : NSMutableArray = []
    
    //array of all favorited items grabbed from our favorites file
    class func allFavoritedItems() -> NSMutableArray {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var allFavorited : NSArray? = userDefaults.objectForKey("favorited") as? NSArray
        if allFavorited {
            return NSMutableArray(array: allFavorited)
        } else {
            return NSMutableArray()
        }
    }
    
    //add this item to the array of our favorited items and update plist
    class func removeFromFavoritedItems(item_id_string : NSString) {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var favorited    = self.allFavoritedItems()
        favorited.removeObject(item_id_string)
        userDefaults.setObject(favorited, forKey: "favorited")
        userDefaults.synchronize()
    }
    
    //remove this item from the array of our favorited items and update plist
    class func addToFavoritedItems(item_id_string : NSString) {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var favorited    = self.allFavoritedItems()
        favorited.addObject(item_id_string)
        userDefaults.setObject(favorited, forKey: "favorited")
        userDefaults.synchronize()
    }
}