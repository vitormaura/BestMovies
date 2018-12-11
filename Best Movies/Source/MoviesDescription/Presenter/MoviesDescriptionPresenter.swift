//
//  MoviesDescriptionPresenter.swift
//  Best Movies
//
//  Created by Vitor Maura on 07/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import Kingfisher

protocol MoviesDescriptionDelegate: NSObjectProtocol{
    func startLoading()
    func stopLoading()
    func setImageDefault()
    func setImage(_ image: UIImage)
}

class MoviesDescriptionPresenter {
    
    private weak var delegate:MoviesDescriptionDelegate!
    private var dataBase:FavoriteManager!
    
    init(viewDelegate:MoviesDescriptionDelegate) {
        self.delegate = viewDelegate
        self.dataBase = FavoriteManager()
    }
    
}

extension MoviesDescriptionPresenter {
    func downloadImage(_ url: String, _ name: String, _ imageView: UIImageView){
        self.delegate.startLoading()
        if let url:URL = URL(string: url){
            let resource = ImageResource(downloadURL: url, cacheKey: name)
            imageView.kf.setImage(with: resource, options: nil, completionHandler: { (image, _, _, _) in
                DispatchQueue.main.async(execute: {
                    self.delegate.stopLoading()
                    if let imageResult = image {
                        self.delegate.setImage(imageResult)
                    }else {
                        self.delegate.setImageDefault()
                    }
                })
            })
        }else{
            self.delegate.stopLoading()
            self.delegate.setImageDefault()
        }
    }
    
    func addOrRemoveFavorite(_ viewData: MovieViewData){
        self.dataBase.createOrRemoveFavoriteDataBase(model: createModelFavorite(viewData))
    }
    
    private func createModelFavorite(_ viewData: MovieViewData) -> FavoriteModel{
        let favoriteModel = FavoriteModel()
        favoriteModel.titleMovie = viewData.titleMovie 
        favoriteModel.description = viewData.description 
        favoriteModel.urlPoster = viewData.urlPoster 
        favoriteModel.urlImage = viewData.urlImage 
        favoriteModel.releaseDate = viewData.releaseDate 
        favoriteModel.vote_average = viewData.vote_average 
        favoriteModel.isFavorite = viewData.isFavorite 
        favoriteModel.favoriteImage = viewData.favoriteImage
        favoriteModel.genres = self.createModelGenre(viewData.genres)
        return favoriteModel
    }
    
    private func createModelGenre(_ names: [String]) -> [FavoriteGenre] {
        var genresModel = [FavoriteGenre]()
        for name in names{
            let genre = FavoriteGenre()
            genre.name = name
            genresModel.append(genre)
        }
        return genresModel
    }
    
    func checkFavovite(title: String) -> Bool{
        return self.dataBase.checkFavoriteDataBase(title: title)
    }
}
