//
//  DaumImageMeta.swift
//  DaumImageSearch
//
//  Created by 강문성 on 2021/01/01.
//

import Foundation

struct DaumImageMeta {
    var total_count:Int
    var pageable_count:Int
    var is_end:Bool
    
    
    init?(content:[String:Any]) {
        //ISO 8601. [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss].000+[tz]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        guard let total_count = content["total_count"] as? Int,
              let pageable_count = content["pageable_count"] as? Int,
              let is_end = content["is_end"] as? Bool
        else{
            return nil
        }
        self.total_count = total_count
        self.pageable_count = pageable_count
        self.is_end = is_end
     
        
    }
}
