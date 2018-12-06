//
//  MovieCollectionViewCell.swift
//  Best Movies
//
//  Created by Vitor Maura on 05/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class MovieCollectionViewCell: UICollectionViewCell {
    
    //MARK: - OUTLETS -
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitleMovie: UILabel!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var loadingImageView: LOTAnimationView!
}

//MARK: - AUX METHODS -
extension MovieCollectionViewCell {
    func prepare(viewData: MovieViewData){
        self.labelTitleMovie.text = viewData.titleMovie
        self.downloadImage(viewData.urlImage, viewData.titleMovie, self.imageMovie)
    }
    
    private func downloadImage(_ url: String, _ name: String, _ imageView: UIImageView){
        self.startLoading()
        if let url:URL = URL(string: url){
            let resource = ImageResource(downloadURL: url, cacheKey: name)
            imageView.kf.setImage(with: resource, options: nil, completionHandler: { (image, _, _, _) in
                DispatchQueue.main.async(execute: {
                    self.stopLoading()
                    if let imageResult = image {
                        self.imageMovie.image = imageResult
                    }else {
                        self.imageMovie.image = self.getImageDefault()
                    }
                })
            })
        }else{
            self.stopLoading()
            self.imageMovie.image = self.getImageDefault()
        }
    }
    
    private func getImageDefault() -> UIImage{
        if let image = UIImage(named: "errorImage"){
            return image
        }
        return UIImage()
    }
    
    func startLoading(){
        self.loadingImageView.isHidden = false
        self.loadingImageView.setAnimation(named: "loader")
        self.loadingImageView.play()
        self.loadingImageView.loopAnimation = true
    }
    
    func stopLoading(){
        self.loadingImageView.isHidden = true
        self.loadingImageView.pause()
    }
}

