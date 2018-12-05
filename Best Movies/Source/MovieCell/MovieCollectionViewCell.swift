//
//  MovieCollectionViewCell.swift
//  Best Movies
//
//  Created by Vitor Maura on 05/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitleMovie: UILabel!
    
    
    func prepare(viewData: MovieViewData){
        self.labelTitleMovie.text = viewData.titleMovie
        self.downloadImage(viewData.urlImage, viewData.titleMovie, self.imageMovie)
    }
    
}

extension MovieCollectionViewCell {
    private func downloadImage(_ url: String, _ name: String, _ imageView: UIImageView){
        self.startLoading()
        if let url:URL = URL(string: url){
            let resource = ImageResource(downloadURL: url, cacheKey: name)
            imageView.kf.setImage(with: resource, options: nil, completionHandler: {
                (image, _, _, _) in
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
        if let image = UIImage(named: "avatar-default"){
            return image
        }
        return UIImage()
    }
    
    func startLoading(){
        print("1")
    }
    
    func stopLoading(){
        print("2")
    }
}

