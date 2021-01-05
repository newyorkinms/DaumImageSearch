//
//  DaumImage.swift
//  DaumImageSearch
//
//  Created by 강문성 on 2021/01/01.
//

import Foundation
/**
 collection    string    컬렉션
 thumbnail_url    string    미리보기 이미지 URL
 image_url    string    이미지 URL
 width    integer    이미지의 가로 길이
 height    integer    이미지의 세로 길이
 display_sitename    string    출처
 doc_url    string    문서 URL
 datetime    datetime    문서 작성시간. ISO 8601. [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss].000+[tz]

 */

struct DaumImage   {
    var collection:String
    var thumbnail_url:String
    var image_url:String
    var width:Int
    var height:Int
    var display_sitename:String
    var doc_url:String
    var dateTime:String
    
    init?(content:[String:Any]) {

        guard let collection = content["collection"] as? String,
              let thumbnail_url = content["thumbnail_url"] as? String,
              let image_url = content["image_url"] as? String,
              let width = content["width"] as? Int,
              let height = content["height"] as? Int,
              let display_sitename = content["display_sitename"] as? String,
              let doc_url = content["doc_url"] as? String,
              let dateTime = content["datetime"] as? String else{
            return nil
        }
        self.collection = collection
        self.thumbnail_url = thumbnail_url
        self.image_url = image_url
        self.width = width
        self.height = height
        self.display_sitename = display_sitename
        self.doc_url = doc_url
        self.dateTime = dateTime
        
    }
}
