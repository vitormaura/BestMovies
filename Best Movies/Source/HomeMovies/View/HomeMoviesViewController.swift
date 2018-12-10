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
    @IBOutlet weak var labelMessage: UILabel!
    
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
        self.moviesCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.insertSubview(ImageHelper.addNavBarImage(navigationController!, "logo"), at: 1)
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

//MARK: - COLLECTIONVIEW FLOWLAYOUT DELEGATE -
extension HomeMoviesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.44, height: self.view.frame.height * 0.39)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "homeSegue", sender: indexPath.row)
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
            self.labelMessage.text = "Loading movies..."
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
            self.labelMessage.text = "No connection. Tap here to try again"
        }
    }
    
    func errorGeneric(){
        UIView.animate(withDuration: 0.2) {
            self.loadingView.isHidden = false
            self.moviesCollectionView.isHidden = true
            self.loadingView.setAnimation(named: "search")
            self.loadingView.play()
            self.loadingView.loopAnimation = true
            self.labelMessage.text = "An error has ocurred. Tap here to try again"
        }
    }
    
    func setMovie(_ viewData: HomeMovieViewData) {
        self.viewData = viewData
        self.moviesCollectionView.reloadData()
    }
}

//MARK: - AUX METHODS -
extension HomeMoviesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSegue" {
            let viewController = segue.destination as! MoviesDescriptionViewController
            viewController.viewData = self.viewData.movieList[sender as! Int]
        }
    }
}
