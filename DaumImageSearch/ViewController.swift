//
//  ViewController.swift
//  DaumImageSearch
//
//  Created by 강문성 on 2021/01/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var imgSearchBar: UISearchBar!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imgCollectionView.delegate = self
        var reqUrl = "https://dapi.kakao.com/v2/search/image?sort=accuracy&page=1&size=80&query=%EC%84%A4%ED%98%84"
        let headers: HTTPHeaders = [ "Authorization" :  "KakaoAK 81b2a17401df65065a31b037b96a42a1" ]
        RxAlamofire.requestJSON(.get, reqUrl,headers: headers)
                        .debug()
                        .subscribe(onNext: { [weak self] (r, json) in
                            if let dict = json as? [String: AnyObject] {
                                print(dict)
                            }
                            }, onError: { [weak self] (error) in
                                //self?.displayError(error as NSError)
                        })
                        .disposed(by: disposeBag)
    

        imgSearchBar
          .rx.text
          .orEmpty
          .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
          .distinctUntilChanged()
          .filter({ !$0.isEmpty })
          .subscribe(onNext: { [unowned self] query in
            print("query: \(query)")
          })
          .disposed(by: disposeBag)

        
    }


}

extension ViewController : UICollectionViewDelegate{
    
}

