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
    
    //MARK: - OUTLETS -
    @IBOutlet weak var loadingView: LOTAnimationView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    //MARK: - VARIABLES -
    private var presenter:MoviesHomePresenter!
    private var viewData = HomeMovieViewData()
    private var isLoading = false
    private var currentPage = 1
}

//MARK: - LIFE CYCLE -
extension HomeMoviesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MoviesHomePresenter(viewDelegate: self)
        self.presenter.getMovies(page: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.insertSubview(self.addNavBarImage(), at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.subviews[1].removeFromSuperview()
    }
}

//MARK: - COLLECTIONVIEW DATASOURCE -
extension HomeMoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewData.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        UIView.animate(withDuration: 0.6) {
            cell.spruce.animate([.expand(.moderately), .slide(.down, .moderately)])
        }
        cell.prepare(viewData: viewData.movieList[indexPath.row])
        return cell
    }
}

//MARK: - COLLECTIONVIEW DELEGATE -
extension HomeMoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.viewData.movieList.count - 10, !self.isLoading, self.viewData.movieList.count != self.viewData.totalMovies {
            self.currentPage += 1
            self.presenter.getMoviesForInfiniteScroll(page: currentPage)
        }
    }
}

//MARK: - HOMEVIEWDELEGATE -
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

//MARK: - AUX METHODS -
extension HomeMoviesViewController {
    func addNavBarImage() -> UIView{
        let navController = navigationController
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController?.navigationBar.frame.size.width
        let bannerHeight = navController?.navigationBar.frame.size.height
        let bannerX = bannerWidth! / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight! / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: 240, height: 60)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
