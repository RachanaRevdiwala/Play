//
//  ArraySortingManager.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import Foundation

enum ArraySortingType {
    
    case alpha, duration, created, modified, size
    
    var resourceKey: URLResourceKey {
        switch self {
        case .created: return .creationDateKey
        case .modified: return .contentModificationDateKey
        case .size: return .fileSizeKey
        default: return .creationDateKey
        }
    }
    
    var title: String {
        switch self {
        case .alpha: return "Alphanumerically"
        case .duration: return "Duration"
        case .created: return "Insertion date"
        case .modified: return "Last modification date"
        case .size: return "File size"
        }
    }
}

enum ArraySortingManager {
    
    private enum Key: String {
        case defultSortType
        case ascendingOrder
    }
    
    
    static func getCurrentSortType() -> ArraySortingType {
        
        let  sorttype = UserDefaults.standard.integer(forKey: Key.defultSortType.rawValue)
        switch sorttype {
        case 0: return .alpha
        case 1: return .duration
        case 2: return .created
        case 3: return .modified
        case 4: return .size
        default: return .alpha
        }
    }
    
    static func getAescendingOrder() -> Bool {
        return true
    }
    
    static func sortedList(sender:[URL]) -> [URL]{
        
        var mynewlist = sender
        var key = getCurrentSortType()
        let ascending = getAescendingOrder()
        
        if getCurrentSortType() == .duration {
            key = ArraySortingType.alpha
        }
        
        do
        {
            try mynewlist.sort { values1, values2 in
                
            
                
                let url1 = try values1.resourceValues(forKeys: [key.resourceKey])
                let url2 = try values2.resourceValues(forKeys: [key.resourceKey])
            
                if let date1 = url1.allValues.first?.value as? Date, let date2 = url2.allValues.first?.value as? Date {
                    return date1.compare(date2) == (ascending ? .orderedAscending : .orderedDescending)
                }
                
                return true
            }
            
            return mynewlist
            
        } catch {
            
            return mynewlist
        }
    }
    


    static func sortedList(sender:[Videofile],  complition:@escaping ([Videofile])->()){
        
        var mynewlist = sender
        let key = getCurrentSortType()
        let ascending = getAescendingOrder()
        
        do
        {
            try mynewlist.sort { values1, values2 in
                
   
                
                let url1 = try values1.url.resourceValues(forKeys: [key.resourceKey])
                let url2 = try values2.url.resourceValues(forKeys: [key.resourceKey])
                
   
                if let date1 = url1.allValues.first?.value as? Date, let date2 = url2.allValues.first?.value as? Date {
                    return date1.compare(date2) == (ascending ? .orderedAscending : .orderedDescending)
                }
                
                
                return true
            }
            
            complition(mynewlist)
            
        } catch {
            
            complition(mynewlist)
        }
    }
}
