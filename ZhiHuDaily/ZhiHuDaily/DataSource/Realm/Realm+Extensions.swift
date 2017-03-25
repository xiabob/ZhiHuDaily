//
//  RLMResults+Extensions.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/25.
//  Copyright © 2017年 xiabob. All rights reserved.
//


import RealmSwift

extension Results {
    
    ///change Results to [Object] array
    func toArray<T: Object>() -> [T] {
        return self.map {  item -> T in
            return (item as! T)
        }
    }
}



extension Object {
    
    class func getResults(from realm: Realm, withPredicate predicate: NSPredicate? = nil) -> Results<Object> {
        if let predicate = predicate  {
            return realm.objects(self).filter(predicate)
        } else {
            return realm.objects(self)
        }
    }
    
    class func getEntities<T: Object>(from realm: Realm, withPredicate predicate: NSPredicate? = nil) -> [T] {
        return getResults(from: realm, withPredicate: predicate).toArray()
    }
    
    class func getEntities<T: Object>(from realm: Realm, withPredicate predicate: NSPredicate? = nil, using properties: [SortDescriptor]) -> [T] {
        return getResults(from: realm, withPredicate: predicate).sorted(by: properties).toArray()
    }
    
    class func getEntity<T: Object, K>(from realm: Realm, byPrimaryKey keyValue: K) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: keyValue)
    }
}


protocol RLMObjectHelperProtocol: NSObjectProtocol {
    var defaultPredicate: NSPredicate? {get}
    var defaultSortDescriptor: [SortDescriptor]? {get}
}

extension RLMObjectHelperProtocol where Self: RealmSwift.Object {
    var defaultPredicate: NSPredicate? {return nil}
    var defaultSortDescriptor: [SortDescriptor]? {return nil}
}
