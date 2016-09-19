//
//  CacheStore.swift
//  CacheWrapper
//
//  Created by Karan Satia on 9/15/16.
//  Copyright © 2016 Karan Satia. All rights reserved.
//

import UIKit

class CacheStore: NSObject {
    // we need to a. archive things to disk b. check for a way to determine if objects are expired (when you try to access, run a check) -> if expired, trash it
    // will be using archiver to write to disk (check for cache folder in documentation)
    // we will have multiple caches for different object types (a cache for GSMcoordinates, a cache for UIImages for a particular part of an application -> the easiest way to differentiate between caches holding similar objects would be by name. MUST HAVE A NAME PROPERTY
    // We need support for clearing out an entire cache by name
    // We need support for clearing out all caches
    // The cache that will be implemented is just an instance of NSCache (performance with hash functions) - should be internal constant since we don't want anybody importing the framework to have direct access to the internal structure
    //  Create a dispatch queue OR an NSOperation depending on what we end up doing with API response caching.
    // Consider using enum in CacheStore to determine how far off object expiration is. NSDate has NSDate.distanceFuture(), etc.
    //start by initializing a cache using the internal cache variable backed by NSCache (instance of that cache). A file manager object is just used as a wrapper around lower level I/O operations and directory access. 
    
    let cache = NSCache<AnyObject, AnyObject>()
    let fileManager = FileManager ()
    let name: String
    let directory: NSURL
    
    
    // Declare as public so that the function is accessible to source files outside of this module (ie files being built by other developers who are importing this framework)
    
    public init(cacheName: String, directory: NSURL?, fileProtection: String? = nil) throws {
        // attribute name to both class property for cache name
        // NSCache has a name property already which seems to be used to differentiate between caches when a delegate method is called when objects are about to be evicted from the cache. This allows you to see which caches are evicting objects.
        // We're using the name constant for creating a file path for each cache created.
        self.name = cacheName
        self.directory = directory!
    }
}
