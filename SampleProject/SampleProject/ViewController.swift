//
//  ViewController.swift
//  SampleProject
//
//  Created by Sakon Ratanamalai on 24/6/2562 BE.
//  Copyright © 2562 Sakon Ratanamalai. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let stepBag = DisposeBag()
    let api = APIClient.shared
    let otherApi = APIOtherClient.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Test Call Url "https://jsonplaceholder.typicode.com"
        otherApi.getOtherUser()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ r in
                
                guard let result = r.value else{
                    return self.alertPopup(initMessage: r.error!.errorFriendlyEn!)
                }
                result.forEach {
                    print("User ID: \($0.id), User Title: \($0.title)")
                }
            },onError:{ e in
                self.alertPopup(initMessage: "Application Error")
            }).disposed(by: stepBag)
        
        //Test Call Url "https://webstarter.megazy.com"
        let postPlace = PostPlace(lat: 13.752030,lng: 100.576115, rowPerPage: 10, pageNumber: 1)
        api.getNearby(postData:postPlace)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ r in
                
                guard let response = r.value else{
                    return self.alertPopup(initMessage: r.error!.errorFriendlyEn!)
                }
                response.result?.forEach {
                    print("Place ID: \($0.placeID), Place Name: \($0.name!)")
                }
            },onError:{ e in
                self.alertPopup(initMessage: "Application Error")
            }).disposed(by: stepBag)
        
        //Test Call get with query url "http://search.megazy.com"
        apiSearch
            .searchQuery(postData: QuerySearch(plim: 10, pno: 1,lat: 13.752030, lng: 100.576115, dist: 2, shape: "cr"))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ r in
                
                guard let response = r.value else{
                    return self.alertPopup(initMessage: r.error!.errorFriendlyEn!)
                }
                response.Data.itemData.forEach{
                    print("Category: \($0.category), Image: \($0.image)")
                }
            },onError:{ e in
                self.alertPopup(initMessage: "Application Error")
            }).disposed(by: stepBag)
        
        
    }
    
    func alertPopup(initMessage:String){
        let alert = UIAlertController(title: "Information", message: initMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

