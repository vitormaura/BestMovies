//
//  MovieCollectionViewCell.swift
//  Best Movies TV
//
//  Created by Vitor Maura on 29/01/19.
//  Copyright © 2019 Vitor Maura. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var loadingImageView: LOTAnimationView!
    
}

//MARK: - AUX METHODS -
extension MovieCollectionViewCell {
    func prepare(viewData: MovieViewData){
        self.downloadImage(viewData.urlImage, viewData.titleMovie, self.movieImage)
    }
    
    private func downloadImage(_ url: String, _ name: String, _ imageView: UIImageView){
        self.startLoading()
        if let url:URL = URL(string: url){
            let resource = ImageResource(downloadURL: url, cacheKey: name)
            imageView.kf.setImage(with: resource, options: nil, completionHandler: { (image, _, _, _) in
                DispatchQueue.main.async(execute: {
                    self.stopLoading()
                    if let imageResult = image {
                        imageView.image = imageResult
                    }else {
                        imageView.image = self.getImageDefault()
                    }
                })
            })
        }else{
            self.stopLoading()
            imageView.image = self.getImageDefault()
        }
    }
    
    private func getImageDefault() -> UIImage{
        if let image = UIImage(named: "errorImage"){
            return image
        }
        return UIImage()
    }
    
    private func startLoading(){
        self.loadingImageView.isHidden = false
        self.loadingImageView.setAnimation(named: "loader")
        self.loadingImageView.play()
        self.loadingImageView.loopAnimation = true
    }
    
    private func stopLoading(){
        self.loadingImageView.isHidden = true
        self.loadingImageView.pause()
    }
}
