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
    @IBOutlet weak var favoriteView: LOTAnimationView!
    @IBOutlet weak var loadingImageView: LOTAnimationView!
    
    //MARK: - CONSTANTS -
    private let dataBase = FavoriteManager()
}

//MARK: - OVERRIDE METHODS -
extension MovieCollectionViewCell {
    override func prepareForReuse() {
        self.imageMovie.image = nil
        self.imageMovie.kf.cancelDownloadTask()
    }
}

//MARK: - AUX METHODS -
extension MovieCollectionViewCell {
    func prepare(viewData: MovieViewData){
        self.labelTitleMovie.text = viewData.titleMovie
        self.downloadImage(viewData.urlImage, viewData.titleMovie)
        self.setFavorite(title: viewData.titleMovie)
    }
    
    private func downloadImage(_ url: String, _ name: String) {
        self.startLoading()
        if let url:URL = URL(string: url){
            let resource = ImageResource(downloadURL: url, cacheKey: name)
            UIImageView().kf.setImage(with: resource, options: nil, completionHandler: { (image, _, _, _) in
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
        guard let image = UIImage(named: "errorImage") else { return UIImage() }
        return image
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
    
    func setFavorite(title: String) {
        self.favoriteView.setAnimation(named: "favourite_app_icon")
        guard self.dataBase.checkFavoriteDataBase(title: title) else { return }
        self.favoriteView.play()
    }
}

