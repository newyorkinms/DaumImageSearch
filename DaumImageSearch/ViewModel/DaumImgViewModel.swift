//
//  DaumImgViewModel.swift
//  DaumImageSearch
//
//  Created by 강문성 on 2021/01/01.
//

import Foundation
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire

class DaumImageViewModel {

    func searchDaumImage(page:Int,pagingSize:Int,query:String, task:@escaping ((Any)->Void)) {
        let reqUrl = "https://dapi.kakao.com/v2/search/image?sort=accuracy&page=\(page)&size=\(pagingSize)&query=" + query
        let headers: HTTPHeaders = [ "Authorization" :  "KakaoAK 81b2a17401df65065a31b037b96a42a1" ]
        let escapedString = Util.makeStringKoreanEncoded(reqUrl)

        RxAlamofire.requestJSON(.get, escapedString,headers: headers).subscribe(onNext: { [weak self] (r, json) in
            task(json)
        }) { (err) in
            print(err)
        }
    }

    static func pareData(data: Any) -> [DaumImage] {

        guard let items = data as? [String: Any]  else {
            return []
        }
        var daumImages = [DaumImage]()
        
        
        guard let document = items["documents"] as? NSArray else {
            return []
        }
         
        document.forEach{ item in
            guard let img = ( item ) as? [String:Any],
                  let daumImg = DaumImage(content: img) else {
                
                return
            }
            daumImages.append(daumImg)
        }

        return daumImages
    }
    static func pareMetaData(data: Any) -> DaumImageMeta? {

        guard let items = data as? [String: Any]  else {
            return nil
        }
        print( " pareMetaData items : \(items)"  )
        
        guard let document = items["meta"] as? [String:Any] else {
            return nil
        }
         
        guard let meta = DaumImageMeta.init(content: document) else{
            return nil
        }

        return meta
    }
}
