//
//  CachedObjectWrapper.swift
//  CacheWrapper
//
//  Created by Karan Satia on 9/14/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import UIKit
import Foundation

//  UserDefaults && other methods of object graph persistence require being archived and encoded NSKeyedArchiver && the NSCoder protocol only work with subclasses of NSObject. As a result, we must subclass.
class CachedObjectWrapper: NSObject {
    let value: AnyObject
    let expiration: NSDate
    
    var hasExpired: Bool {
        return self.expiration.isInThePast
    }
    
    //designated initializer
    init(value:AnyObject, expiration: NSDate) {
        self.value = value
        self.expiration = expiration
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        guard let val = aDecoder.decodeObject(forKey: "value"),
            let expiry = aDecoder.decodeObject(forKey: "expiration") as? NSDate else {
                return nil
        }
        self.value = val as AnyObject
        self.expiration = expiry
        super.init()
    }
    
    func encodeWithEncoder(aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
        aCoder.encode(expiration, forKey: "expiration")
    }
}
    
    
extension NSDate {
    var isInThePast: Bool {
        get {
            return self.timeIntervalSinceNow < 0
        }
    }
}


    //required nscoder init and encodeWithEncoder function. for the required nscover, assert that a constant can be assigned to the decoded.objectforKey("value"), assert that constant can be assigned to "expiration" else return. if you can proceed, assign constants to file-scoped vars and then call super init. THIS IS FOR DECODING.
    //to encode, call encodeWithEncoder and just call encodeObject on your coder being passed.
    
    

