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
import SDWebImage
import Alamofire

class SearchViewController: UIViewController {

    
    @IBOutlet weak var imgSearchBar: UISearchBar!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    var imgList:[DaumImage] = []
    
    var paginMetaData:DaumImageMeta?
    let pagingSize = 30
    var page = 1
    
    let disposeBag = DisposeBag()
    var viewModel = DaumImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgCollectionView.delegate = self
        self.imgCollectionView.dataSource = self

        bindTask()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    func bindTask() {

        imgSearchBar
          .rx.text //
          .orEmpty //
          .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
          .distinctUntilChanged()
          .subscribe(onNext: { [unowned self] query in // subscribe

            if( query.isEmpty ){
                imgList.removeAll()
                self.imgCollectionView.reloadData()
            }else{
                //검색을 진행할 경우 페이징 처리 초기화
                print("  query " + query)
                page = 1
                imgList.removeAll()
                
                viewModel.searchDaumImage(page: page, pagingSize: pagingSize, query: query) { (json) in
                    guard let meta = (DaumImageViewModel.pareMetaData(data: json)) else{
                        Util.AlertEmpty(vc: self)
                        return
                    }
                    if(meta.total_count == 0){
                        Util.AlertEmpty(vc: self)
                    }
                    self.paginMetaData = meta
                    self.imgList.append(contentsOf: DaumImageViewModel.pareData(data: json))
                    self.imgCollectionView.reloadData()
                    imgCollectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
                }
            }
          })
          .disposed(by: disposeBag)

        imgSearchBar.rx.searchButtonClicked
            .subscribe(onNext: { () in
                self.view.endEditing(true)
            })
            .disposed(by: self.disposeBag)

    }

    //이미지 클릭시 상세 페이지로 이동
    private func showDetailDaumImage(_ daumImg: DaumImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        viewController.daumImg = daumImg
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

extension SearchViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imgCollectionView.dequeueReusableCell(withReuseIdentifier: "ImgCell", for: indexPath) as! ImgCell
        var daumImg = imgList[indexPath.row]
        let url = URL(string: daumImg.image_url)!

        cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder-image"))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let daumImg = imgList[indexPath.row]
        
        viewController.daumImg = daumImg
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 3 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
    
    //콜렉션뷰의 스크롤이 끝에 도달을 하면 다음 페이지를 호출 하여 무한 페이징 처리
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard  let meta = paginMetaData else {
            return
        }
        if( !meta.is_end ){
            guard let query = self.imgSearchBar.text else{
                return
            }
            page = page + 1
            
            viewModel.searchDaumImage(page: page, pagingSize: pagingSize, query: query) { (json) in
                guard let meta = (DaumImageViewModel.pareMetaData(data: json)) else{
                    return
                }
                self.paginMetaData = meta
                self.imgList.append(contentsOf: DaumImageViewModel.pareData(data: json))
                self.imgCollectionView.reloadData()
            }
        }

    }
}

