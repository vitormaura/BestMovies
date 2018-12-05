//
//  HomeMoviesViewController.swift
//  Best Movies
//
//  Created by Vitor Maura on 04/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import Spruce


class HomeMoviesViewController: UIViewController {
    
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
        return isLoading ? 10 : viewData.movieList.count
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
        self.isLoading = true
    }
    
    func stopLoading() {
        self.isLoading = false
    }
    
    func setMovie(_ viewData: HomeMovieViewData) {
        self.viewData = viewData
        self.moviesCollectionView.reloadData()
    }
}
