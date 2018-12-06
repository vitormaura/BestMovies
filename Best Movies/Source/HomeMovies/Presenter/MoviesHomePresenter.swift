//
//  MoviesHomePresenter.swift
//  Best Movies
//
//  Created by Vitor Maura on 05/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit

//MARK: - HOMEVIEWDELEGATE -
protocol HomeMovieDelegate: NSObjectProtocol{
    func startLoading()
    func stopLoading()
    func errorConnection()
    func errorGeneric()
    func setMovie(_ viewData: HomeMovieViewData)
}

//MARK: - HOMEVIEWDATA -
struct HomeMovieViewData {
    var totalMovies = 0
    var movieList = [MovieViewData]()
}

struct MovieViewData {
    var titleMovie = ""
    var urlImage = ""
}

//MARK: - PRESENTER -
class MoviesHomePresenter {
    
    private let service:MoviesService!
    private weak var delegate:HomeMovieDelegate!
    private lazy var viewData = HomeMovieViewData()
    
    init(viewDelegate:HomeMovieDelegate) {
        self.delegate = viewDelegate
        self.service = MoviesService()
    }
    
}

//MARK: - SERVICE -
extension MoviesHomePresenter{
    func getMovies(page: Int){
        self.delegate.startLoading()
        if !Reachability.isConnectedToNetwork() {
            self.delegate.errorConnection()
            return
        }
        self.service.getMovies(page: page, completionSuccess: { (movies) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    if let moviesList = movies.results {
                        self.parseModelToViewData(moviesList)
                        self.viewData.totalMovies = movies.total_results ?? 0
                        self.delegate.setMovie(self.viewData)
                        self.delegate.stopLoading()
                    }
                })
            })
        }) { (error) in
            DispatchQueue.main.async{
                self.delegate.errorGeneric()
            }
        }
    }
    
    func getMoviesForInfiniteScroll(page: Int){
        self.service.getMovies(page: page, completionSuccess: { (movies) in
            DispatchQueue.main.async{
                if let moviesList = movies.results {
                    self.parseModelToViewData(moviesList)
                    self.delegate.setMovie(self.viewData)
                    self.delegate.stopLoading()
                }
            }
        }) { (_) in
            
        }
    }
}

//MARK: - AUX METHODS -
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
