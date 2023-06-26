//
//  LaunchOnStartup.swift
//  Late No More
//
//  Created by Prashant Sawnani on 26/06/23.
//

class LaunchOnStartup {
    static func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
        let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
        )?.takeRetainedValue() as LSSharedFileList?
        if loginItemsRef != nil {
            
            if let LSSharedFileListCopySnapshot = LSSharedFileListCopySnapshot(loginItemsRef!, nil){
                
                let loginItems = LSSharedFileListCopySnapshot.takeRetainedValue() as Array
                
                if loginItems.count == 0 {
                    return (nil, kLSSharedFileListItemBeforeFirst.takeRetainedValue())
                }
                
                let lastItemRef: LSSharedFileListItem = loginItems.last as! LSSharedFileListItem
                
                for currentItemRef in loginItems as! [LSSharedFileListItem] {
                    if let itemUrl = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
                        if (itemUrl.takeRetainedValue() as URL) == appUrl {
                            return (currentItemRef, lastItemRef)
                        }
                    }
                }
                return (nil, lastItemRef)
            }
            
        }
        return (nil, nil)
    }
    
    static func setLaunchAtStartup(_ shouldLaunch: Bool) {
        
        let itemReferences = itemReferencesInLoginItems()
        let alreadyExists = (itemReferences.existingReference != nil)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
        )?.takeRetainedValue() as LSSharedFileList?
        
        if loginItemsRef != nil && itemReferences.lastReference != nil
        {
            if shouldLaunch
            {
                if !alreadyExists
                {
                    
                    let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath) as CFURL
                    LSSharedFileListInsertItemURL(
                        loginItemsRef!,
                        itemReferences.lastReference!,
                        nil,
                        nil,
                        appUrl,
                        nil,
                        nil
                    )
                }
            }
            else
            {
                if alreadyExists
                {
                    let addLoginitemObject: addLoginitem = addLoginitem()
                    let deletitem = addLoginitemObject.itemRefInLoginItems()
                    print(deletitem)
                }
            }
            
        }
    }
}
