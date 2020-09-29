//
//  FavoriteMovieTableViewCell.swift
//  Best Movies
//
//  Created by Vitor Maura on 09/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class FavoriteMovieTableViewCell: UITableViewCell {
    
    //MARK: - OUTLETS -
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var loadingView: LOTAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: - OVERRIDE METHODS -
extension FavoriteMovieTableViewCell {
    override func prepareForReuse() {
        self.imageCover.image = nil
        self.imageCover.kf.cancelDownloadTask()
    }
}

//MARK: - AUX METHODS -
extension FavoriteMovieTableViewCell {
    func prepare(_ viewData: FavoriteMovieViewData){
        self.labelTitle.text = viewData.titleMovie
        self.labelDate.text = viewData.releaseDate
        self.textDescription.text = viewData.description
        self.downloadImage(viewData.urlImage, viewData.titleMovie)
    }
    
    private func downloadImage(_ url: String, _ name: String){
        self.startLoading()
        if let url:URL = URL(string: url){
            let resource = ImageResource(downloadURL: url, cacheKey: name)
            UIImageView().kf.setImage(with: resource, options: nil, completionHandler: { (image, _, _, _) in
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
        guard let image = UIImage(named: "errorImage") else { return UIImage() }
        return image
    }
    
    func startLoading(){
       self.loadingView.setAnimation(named: "loader")
       self.loadingView.loopAnimation = true
       self.loadingView.isHidden = false
       self.loadingView.play()
    }
    
    func stopLoading(){
       self.loadingView.isHidden = true
       self.loadingView.pause()
    }
}
