//
//  FavoriteMovieTableViewCell.swift
//  Best Movies
//
//  Created by Vitor Maura on 09/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import Kingfisher

class FavoriteMovieTableViewCell: UITableViewCell {
    
    //MARK: - OUTLETS -
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: - AUX METHODS -
extension FavoriteMovieTableViewCell {
    func prepare(_ viewData: FavoriteMovieViewData){
        self.labelTitle.text = viewData.titleMovie
        self.labelDate.text = viewData.releaseDate
        self.textDescription.text = viewData.description
        self.downloadImage(viewData.urlImage, viewData.titleMovie, UIImageView())
    }
    
    private func downloadImage(_ url: String, _ name: String, _ imageView: UIImageView){
        self.startLoading()
        if let url:URL = URL(string: url){
            let resource = ImageResource(downloadURL: url, cacheKey: name)
            imageView.kf.setImage(with: resource, options: nil, completionHandler: { (image, _, _, _) in
                DispatchQueue.main.async(execute: {
                    self.stopLoading()
                    if let imageResult = image {
                        self.imageCover.image = imageResult
                    }else {
                        self.imageCover.image = self.getImageDefault()
                    }
                })
            })
        }else{
            self.stopLoading()
            self.imageCover.image = self.getImageDefault()
        }
    }
    
    private func getImageDefault() -> UIImage{
        if let image = UIImage(named: "errorImage"){
            return image
        }
        return UIImage()
    }
    
    func startLoading(){
       //
    }
    
    func stopLoading(){
       //
    }
}
