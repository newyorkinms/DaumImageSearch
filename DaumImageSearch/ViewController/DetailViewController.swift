//
//  DetailViewController.swift
//  DaumImageSearch
//
//  Created by 강문성 on 2021/01/02.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SDWebImage
class DetailViewController:UIViewController{
    
    var daumImg:DaumImage?
    

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var display_sitename: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let img = daumImg else {
            return
        }
        
        
        if( !img.display_sitename.isEmpty ){
            display_sitename.text = "출처:" + img.display_sitename
            display_sitename.isHidden = false
        }
        if( !img.dateTime.isEmpty ){
            dateTime.text = img.dateTime
            dateTime.isHidden = false
        }
        

        let url = URL(string: img.image_url)!

        imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder-image") )
        
        let ratio = imgView.frame.size.width / imgView.frame.size.height
        imgView.widthAnchor
          .constraint(equalTo: imgView.heightAnchor, multiplier: ratio).isActive = true

        
        
        backBtn.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
         }.disposed(by: disposeBag)

     
    }

}
