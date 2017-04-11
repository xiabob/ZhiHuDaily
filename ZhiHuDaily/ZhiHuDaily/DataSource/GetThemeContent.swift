//
//  GetThemeContent.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/11.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetThemeContent: XBAPIBaseManager, ManagerProtocol {
    var themeId = 0
    var themeModel = ThemeModel()
    var newsModels = [NewsModel]()
    var editorModels = [EditorModel]()
    
    var path: String {
        return "/theme/\(themeId)"
    }
    
    func parseResponseData(_ data: AnyObject) {
        let json = JSON(data)
        
        
        let realm = RealmManager.shared.defaultRealm
        try? realm?.write {
            //set theme
            if let theme = realm?.object(ofType: Theme.self, forPrimaryKey: themeId) {
                theme.backgroundImage = json["background"].stringValue
                themeModel = ThemeModel(from: theme)
            }
            
            //set news
            var news = [News]()
            let stories = json["stories"].arrayValue
            for newsDic in stories {
                let newsId = newsDic["id"].intValue
                if let localNews = realm?.object(ofType: News.self, forPrimaryKey: newsId) {
                    localNews.update(from: newsDic, dateString: "")
                    news.append(localNews)
                } else {
                    let newNews = News(from: newsDic, dateString: "")
                    news.append(newNews)
                }
            }
            newsModels = news.map({ (value) -> NewsModel in
                return NewsModel(from: value)
            })
            
            //set editors
            let editorsJson = json["editors"].arrayValue
            var editors = [Editor]()
            for editorDic in editorsJson {
                let editorId = editorDic["id"].intValue
                if let localEditor = realm?.object(ofType: Editor.self, forPrimaryKey: editorId) {
                    localEditor.update(from: editorDic)
                    editors.append(localEditor)
                } else {
                    let newEditor = Editor(from: editorDic)
                    editors.append(newEditor)
                }
            }
            editorModels = editors.map({ (value) -> EditorModel in
                return EditorModel(from: value)
            })
        }
    }
    
}
