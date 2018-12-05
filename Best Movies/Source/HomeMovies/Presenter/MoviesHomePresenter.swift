//
//  MoviesHomePresenter.swift
//  Best Movies
//
//  Created by Vitor Maura on 05/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit


protocol HomeMovieDelegate: NSObjectProtocol{
    func startLoading()
    func stopLoading()
    func errorConnection()
    func setMovie(_ viewData: HomeMovieViewData)
}

struct HomeMovieViewData {
    var movieList = [MovieViewData]()
}

struct MovieViewData {
    var titleMovie = ""
    var urlImage = ""
}

class MoviesHomePresenter {
    
    private let service:MoviesService!
    private weak var delegate:HomeMovieDelegate!
    private lazy var viewData = HomeMovieViewData()
    
    init(viewDelegate:HomeMovieDelegate) {
        self.delegate = viewDelegate
        self.service = MoviesService()
    }
    
}

extension MoviesHomePresenter{
    func getMovies(){
        self.delegate.startLoading()
        if !Reachability.isConnectedToNetwork() {
            self.delegate.errorConnection()
            print("error")
            return
        }
        self.service.getMovies(completionSuccess: { (movies) in
            DispatchQueue.main.async{
                if let moviesList = movies.results {
                    self.parseModelToViewData(moviesList)
                    self.delegate.setMovie(self.viewData)
                    self.delegate.stopLoading()
                }
            }
        }) { (error) in
            //self.delegate.stopLoading()
            print("error")
        }
    }
}

extension MoviesHomePresenter{
    private func parseModelToViewData(_ movies: [Movies]){
        var moviewViewData = MovieViewData()
        for movie in movies{
            moviewViewData.titleMovie = movie.title ?? ""
            moviewViewData.urlImage = "https://image.tmdb.org/t/p/w500\(movie.poster_path ?? "")"
            self.viewData.movieList.append(moviewViewData)
        }
    }
}
