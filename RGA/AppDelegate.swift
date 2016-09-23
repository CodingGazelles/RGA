//
//  AppDelegate.swift
//  RGA
//
//  Created by Tancrède on 9/20/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // Cleaning db and loading everything again
        switch RGADataStack().deleteAll() {
        case .Success(_):
            NSLog("Cleaned DB")
            
        case .Failure(let error):
            NSLog("Unable to clean DB: \(error)")
        }
        
        
        // Loading Contacts and Images
        loadingData()
        
        
        return true
        
    }
    
    
    
    
    /*
    */
    func loadingData() {
        
        
        let stack = RGADataStack()
        
        
        // Loading contacts
        RGAWebServices.defaultServices().loadContacts()
            .onSuccess{ contactList in
                
                
                // Saving contacts
                stack.writeContactList(contactList)
                
                
                // Loading images
                for contact in contactList{
                    
                    
                    // Loading image
                    RGAWebServices.defaultServices().loadUIImage( contact.imageURL)
                        .onSuccess{ image in
                            
                            
                            // Updating Contact DB
                            stack.writeImage( image, contact: contact)
                            
                        }
                        
                        
                        // Loading Image failed
                        .onFailure{ error in
                            
                            
                            // Warning
                            NSLog("Failed loading image \(contact.imageURL)")
                            NSLog("\(error)")
                            
                    }
                    
                }
                
                
                NSLog("All data downloaded")
        }
        
    }

}

