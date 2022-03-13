//
//  Loading.swift
//  AomSook
//
//  Created by khuad on 3/5/2562 BE.
//  Copyright © 2562 megazy. All rights reserved.
//

import Foundation
import SwiftyGif
#if canImport(UIKit)
import UIKit



class Loading {
    static let shared  = Loading()
    
    var imageview:UIImageView?
    
    func show(viewController:UIViewController){
        self.setGif(view:viewController.view)
    }
    func hide(viewController:UIViewController){
        self.imageview?.removeFromSuperview()
    }
    
    private func setGif(view:UIView){
        do{
            let gif =  try UIImage(gifName: "loading")
            self.imageview = UIImageView(gifImage: gif, loopCount: -1)
            imageview?.frame = UIScreen.main.bounds
            imageview?.tag = 101
            imageview?.contentMode = .scaleAspectFit
            imageview?.isUserInteractionEnabled = true
            imageview?.backgroundColor = UIColor.init(white: 0x000, alpha: 0.5)
        }catch{
            fatalError("Loading Image Not Found")
        }
        
        guard let imageview = self.imageview else{return}
        view.subviews.lazy.filter{$0.isKind(of: UIImageView.self) && $0.tag == 101}.lazy.forEach{$0.removeFromSuperview()}
        view.addSubview(imageview)
        
        
    }
}
#endif
