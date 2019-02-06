//
//  MoviesTVViewController.swift
//  Best Movies TV
//
//  Created by Vitor Maura on 29/01/19.
//  Copyright © 2019 Vitor Maura. All rights reserved.
//

import UIKit
import Spruce
import Lottie

class MoviesTVViewController: UIViewController {
    
    @IBOutlet weak var loadingView: LOTAnimationView!
    @IBOutlet weak var collection: UICollectionView!
  
    //MARK: - VARIABLES -
    private var presenter:MoviesHomePresenter!
    private var viewData = HomeMovieViewData()
    private var genreViewData = MoviesGenresViewData()
    private var isLoading = false
    private var currentPage = 1
}

//MARK: - LIFE CYCLE -
extension MoviesTVViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MoviesHomePresenter(viewDelegate: self)
        self.presenter.getGenres()
        self.presenter.getMovies(page: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collection.reloadData()
    }
    
}

//MARK: - COLLECTIONVIEW DATASOURCE -
extension MoviesTVViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewData.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        UIView.animate(withDuration: 0.6) {
            cell.spruce.animate([.expand(.moderately), .slide(.down, .moderately)])
        }
        cell.prepare(viewData: self.viewData.movieList[indexPath.row])
        return cell
    }
}

//MARK: - COLLECTIONVIEW DELEGATE -
extension MoviesTVViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.viewData.movieList.count - 10, !self.isLoading, self.viewData.movieList.count != self.viewData.totalMovies {
            self.currentPage += 1
            self.presenter.getMoviesForInfiniteScroll(page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "homeSegue", sender: indexPath.row)
    }
}

//MARK: - HOMEVIEWDELEGATE -
extension MoviesTVViewController: HomeMovieDelegate {
    func startLoading() {
        UIView.animate(withDuration: 0.2) {
            self.isLoading = true
            self.loadingView.isHidden = false
            self.collection.isHidden = true
            self.loadingView.setAnimation(named: "video_cam")
            self.loadingView.play()
            self.loadingView.loopAnimation = true
        }
    }
    
    func startLoadingInfiniteScroll() {
        self.isLoading = true
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 0.2) {
            self.isLoading = false
            self.loadingView.isHidden = true
            self.collection.isHidden = false
            self.loadingView.pause()
        }
    }
    
    func stopLoadingInfiniteScroll() {
        self.isLoading = false
    }
    
    func errorConnection(){
        UIView.animate(withDuration: 0.2) {
            self.loadingView.isHidden = false
            self.isLoading = false
            self.collection.isHidden = true
            self.loadingView.setAnimation(named: "no_connection")
            self.loadingView.play()
            self.loadingView.loopAnimation = true
        }
    }
    
    func errorGeneric(){
        UIView.animate(withDuration: 0.2) {
            self.loadingView.isHidden = false
            self.isLoading = false
            self.collection.isHidden = true
            self.loadingView.setAnimation(named: "error_cross")
            self.loadingView.play()
            self.loadingView.loopAnimation = true
        }
    }
    
    func setMovie(_ viewData: HomeMovieViewData) {
        self.viewData = viewData
        self.collection.reloadData()
    }
    
    func setGenre(_ viewData: MoviesGenresViewData) {
        self.genreViewData = viewData
    }
}

//MARK: - AUX METHODS -
extension MoviesTVViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSegue" {
            let viewController = segue.destination as! MoviesTVDescriptionViewController
            viewController.viewData = self.viewData.movieList[sender as! Int]
            viewController.genreViewData = self.genreViewData
        }
    }
}

