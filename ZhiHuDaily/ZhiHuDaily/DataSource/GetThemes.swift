//
//  GetThemes.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/10.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetThemes: XBAPIBaseManager, ManagerProtocol, XBAPILocalCache {
    var subscribedThemeModel = [ThemeModel]()
    var unsubscribedThemeModel = [ThemeModel]()
    
    var path: String {
        return "/themes"
    }
    
    var shouldCache: Bool {return true}
    
    func getDataFromLocal(from key: String) -> Data? {
        return nil
    }
    
    func parseResponseData(_ data: AnyObject) {
        let realm = RealmManager.shared.defaultRealm
        try? realm?.write {
            let json = JSON(data)
            
            let subscribedJson = json["subscribed"].arrayValue
            var themes = [Theme]()
            for themeDic in subscribedJson {
                let themeID = themeDic["id"].intValue
                let localTheme = realm?.object(ofType: Theme.self, forPrimaryKey: themeID)
                if let localTheme = localTheme {
                    localTheme.update(from: themeDic)
                    themes.append(localTheme)
                } else {
                    let newTheme = Theme(from: themeDic)
                    newTheme.isSubscribed = true
                    realm?.add(newTheme)
                    themes.append(newTheme)
                }
            }
            self.subscribedThemeModel = themes.map({ (value) -> ThemeModel in
                return ThemeModel(from: value)
            })
            
            
            themes.removeAll()
            let unsubscribedJson = json["others"].arrayValue
            for themeDic in unsubscribedJson {
                let themeID = themeDic["id"].intValue
                let localTheme = realm?.object(ofType: Theme.self, forPrimaryKey: themeID)
                if let localTheme = localTheme {
                    localTheme.update(from: themeDic)
                    themes.append(localTheme)
                } else {
                    let newTheme = Theme(from: themeDic)
                    newTheme.isSubscribed = false
                    realm?.add(newTheme)
                    themes.append(newTheme)
                }
            }
            self.unsubscribedThemeModel = themes.map({ (value) -> ThemeModel in
                return ThemeModel(from: value)
            })
        }
    }
}
