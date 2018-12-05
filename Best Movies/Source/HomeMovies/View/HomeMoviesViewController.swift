//
//  HomeMoviesViewController.swift
//  Best Movies
//
//  Created by Vitor Maura on 04/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import Spruce
import Lottie

class HomeMoviesViewController: UIViewController {
    
    @IBOutlet weak var loadingView: LOTAnimationView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    private var viewData:HomeMovieViewData!
    private var presenter:MoviesHomePresenter!
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MoviesHomePresenter(viewDelegate: self)
        self.presenter.getMovies()
    }
}

extension HomeMoviesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 1 : viewData.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        UIView.animate(withDuration: 0.4) {
            cell.spruce.animate([.expand(.moderately), .slide(.down, .moderately)])
        }
        if !isLoading{
            cell.prepare(viewData: viewData.movieList[indexPath.row])
        }
        return cell
    }
}

extension HomeMoviesViewController: HomeMovieDelegate {
    func startLoading() {
        UIView.animate(withDuration: 0.2) {
            self.isLoading = true
            self.loadingView.isHidden = false
            self.moviesCollectionView.isHidden = true
            self.loadingView.setAnimation(named: "video_cam")
            self.loadingView.play()
            self.loadingView.loopAnimation = true
        }
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 0.2) {
            self.isLoading = false
            self.loadingView.isHidden = true
            self.moviesCollectionView.isHidden = false
            self.loadingView.pause()
        }
    }
    
    func errorConnection(){
        UIView.animate(withDuration: 0.2) {
            self.loadingView.isHidden = false
            self.moviesCollectionView.isHidden = true
            self.loadingView.setAnimation(named: "no_connection")
            self.loadingView.play()
            self.loadingView.loopAnimation = true
        }
    }
    
    func errorGeneric(){
        UIView.animate(withDuration: 0.2) {
            self.loadingView.isHidden = false
            self.moviesCollectionView.isHidden = true
            self.loadingView.setAnimation(named: "search")
            self.loadingView.play()
            self.loadingView.loopAnimation = true
        }
    }
    
    func setMovie(_ viewData: HomeMovieViewData) {
        self.viewData = viewData
        self.moviesCollectionView.reloadData()
    }
}
