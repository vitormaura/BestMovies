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

//MARK: - OVERRIDE METHODS -
extension MovieCollectionViewCell {
    override func prepareForReuse() {
        self.movieImage.image = nil
        self.movieImage.kf.cancelDownloadTask()
    }
}

//MARK: - AUX METHODS -
extension MovieCollectionViewCell {
    func prepare(viewData: MovieViewData){
        self.downloadImage(viewData.urlImage, viewData.titleMovie)
    }
    
    private func downloadImage(_ url: String, _ name: String) {
        self.startLoading()
        if let url:URL = URL(string: url){
            let resource = ImageResource(downloadURL: url, cacheKey: name)
            UIImageView().kf.setImage(with: resource, options: nil, completionHandler: { (image, _, _, _) in
                DispatchQueue.main.async(execute: {
                    self.stopLoading()
                    if let imageResult = image {
                        self.movieImage.image = imageResult
                    }else {
                        self.movieImage.image = self.getImageDefault()
                    }
                })
            })
        }else{
            self.stopLoading()
            self.movieImage.image = self.getImageDefault()
        }
    }
    
    private func getImageDefault() -> UIImage{
        guard let image = UIImage(named: "errorImage") else { return UIImage() }
        return image
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
