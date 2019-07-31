//
//  FavoritesMoviesPresenter.swift
//  Best Movies
//
//  Created by Vitor Maura on 09/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit

//MARK: - FAVORITEMOVIEDELEGATE -
protocol FavoriteMovieDelegate: NSObjectProtocol{
    func setFavoriteMovies(viewData:ListFavoriteMoviesViewData)
    func showEmpty()
}

//MARK: - FAVORITEMOVIVIEWDATA -
struct ListFavoriteMoviesViewData {
    var listFavorites = [FavoriteMovieViewData]()
}

struct FavoriteMovieViewData {
    var titleMovie = ""
    var releaseDate = ""
    var urlImage = ""
    var urlPoster = ""
    var description = ""
    var vote_average = 0.0
    var isFavorite = false
    var favoriteImage = ""
    var genres = [String]()
}

class FavoritesMoviesPresenter {
    
    private weak var delegate:FavoriteMovieDelegate?
    private let dataBase:FavoriteManager!
    private lazy var viewData = ListFavoriteMoviesViewData()
    
    init(viewDelegate:FavoriteMovieDelegate) {
        self.delegate = viewDelegate
        self.dataBase = FavoriteManager()
    }
    
}

//MARK: - AUX METHODS -
extension FavoritesMoviesPresenter{
    func getFavoriteListDataBase(){
        self.viewData.listFavorites.removeAll()
        if let listDataBase = self.dataBase.fetchListFavoriteDataBase(){
            for dataBaseRow in listDataBase{
                self.parseFavoriteModelFromViewData(model: dataBaseRow, listViewData: &self.viewData.listFavorites)
            }
            self.delegate?.setFavoriteMovies(viewData: self.viewData)
        }else{
            self.delegate?.showEmpty()
        }
    }
    
    private func parseFavoriteModelFromViewData(model:FavoriteModel, listViewData: inout [FavoriteMovieViewData]){
        var viewDataFavorite = FavoriteMovieViewData()
        viewDataFavorite.titleMovie = model.titleMovie ?? ""
        viewDataFavorite.description = model.description ?? ""
        viewDataFavorite.urlPoster = model.urlPoster ?? ""
        viewDataFavorite.urlImage = model.urlImage ?? ""
        viewDataFavorite.releaseDate = model.releaseDate ?? ""
        viewDataFavorite.vote_average = model.vote_average ?? 0.0
        viewDataFavorite.isFavorite = model.isFavorite ?? false
        viewDataFavorite.favoriteImage = model.favoriteImage ?? ""
        viewDataFavorite.genres = self.createListGenre(model.genres ?? [])
        listViewData.append(viewDataFavorite)
    }
    
    private func createListGenre(_ genres: [FavoriteGenre]) -> [String] {
        var nameList = [String]()
        for genre in genres{
            var name = ""
            name = genre.name ?? ""
            nameList.append(name)
        }
        return nameList
    }
    
    func removeFavorite(_ viewData: FavoriteMovieViewData){
        self.dataBase.removeFavoriteDataBase(model: createModelFavorite(viewData))
    }
    
    private func createModelFavorite(_ viewData: FavoriteMovieViewData) -> FavoriteModel{
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
    
    func parseHomeViewDataToFavoriteViewData(_ viewData: FavoriteMovieViewData) -> MovieViewData{
        var movieViewData = MovieViewData()
        movieViewData.titleMovie = viewData.titleMovie
        movieViewData.description = viewData.description
        movieViewData.urlPoster = viewData.urlPoster
        movieViewData.urlImage = viewData.urlImage
        movieViewData.releaseDate = viewData.releaseDate
        movieViewData.vote_average = viewData.vote_average
        movieViewData.isFavorite = viewData.isFavorite
        movieViewData.favoriteImage = viewData.favoriteImage
        movieViewData.genres = viewData.genres
        return movieViewData
    }
}
