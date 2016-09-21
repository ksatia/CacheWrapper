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
    
    //consider creating enum for expiration conditions. We can also create an enum for error handling and document for use in try/catch statements.
    
    
    
    
    let cache = NSCache<AnyObject, AnyObject>()
    let fileManager = FileManager ()
    let name: String
    var directory: URL
    
    enum directoryErrors : Error {
        case couldNotCreate
    }
    
    
    // Declare as public so that the function is accessible to source files outside of this module (ie files being built by other developers who are importing this framework)
    public init(cacheName: String, cacheDirectory: URL?, fileProtection: String? = nil) throws{
        
        // NSCache has a name property already which seems to be used to differentiate between caches when a delegate method is called when objects are about to be evicted from the cache. This allows you to see which caches are evicting objects. Not being used here.
        self.name = cacheName
        
        //provide developers with the ability to specify a directory of their choosing - may lead to problems in the future. Consider pulling out this functionality and just using the cache name to create an appropriate filepath.
        if let direc = cacheDirectory {
            self.directory = direc
        }
            
        else {
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            self.directory = url.appendingPathComponent("ksatia.cache/\(cacheName)")
        }

        // catch error in attempting to create directory at path -> CONSIDER WRITING TO FILE V DIRECTORY
        do {
            try fileManager.createDirectory(at: self.directory, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            throw directoryErrors.couldNotCreate
        }
        
        //set file protection values here -> default to max protection, include option in initializer for user specified protection level
    }
    
    public convenience init(cacheName: String) throws {
        do {
            try self.init(cacheName:cacheName, cacheDirectory: nil, fileProtection: nil)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            throw directoryErrors.couldNotCreate
            //fatalError("Directory creation failed: \(error.localizedDescription)")
        }
    }
 
    
    
}

extension CacheStore {
    var getCacheDirectory: URL {
        get {
            return self.directory
        }
    }
}
