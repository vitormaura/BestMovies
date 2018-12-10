//
//  FavoritesMoviesViewController.swift
//  Best Movies
//
//  Created by Vitor Maura on 09/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import Spruce
import Lottie

class FavoritesMoviesViewController: UIViewController {
    
    //MARK: - OUTLETS -
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var emptyView: LOTAnimationView!
    
    //MARK: - VARIABLES -
    private var presenter:FavoritesMoviesPresenter!
    private var viewData = ListFavoriteMoviesViewData()
}
//MARK: - LIFE CYCLE -
extension FavoritesMoviesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = FavoritesMoviesPresenter(viewDelegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.getFavoriteListDataBase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.navigationController?.navigationBar.insertSubview(ImageHelper.addNavBarImage(navigationController!, "favLogo"), at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.subviews[1].removeFromSuperview()
    }
}

//MARK: - TABLEVIEW DELEGATE -
extension FavoritesMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "favoritesSegue", sender: indexPath.row)
    }
}

//MARK: - TABLEVIEW DATASOURCE -
extension FavoritesMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewData.listFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FavoriteMovieTableViewCell
        cell.prepare(viewData.listFavorites[indexPath.row])
        UIView.animate(withDuration: 0.6) {
            cell.spruce.animate([.expand(.moderately), .slide(.down, .moderately)])
        }
        return cell
    }
}

//MARK: - FAVORITEMOVIE DATASOURCE -
extension FavoritesMoviesViewController: FavoriteMovieDelegate {
    func setFavoriteMovies(viewData: ListFavoriteMoviesViewData) {
        self.viewData = viewData
        self.favoritesTableView.reloadData()
        self.emptyView.isHidden = true
        self.favoritesTableView.isHidden = false
        self.emptyView.pause()
    }
    
    func showEmpty() {
        UIView.animate(withDuration: 0.2) {
            self.emptyView.isHidden = false
            self.favoritesTableView.isHidden = true
            self.emptyView.setAnimation(named: "emoji_wink")
            self.emptyView.play()
            self.emptyView.loopAnimation = true
        }
    }
}

//MARK: - AUX METHODS -
extension FavoritesMoviesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesSegue" {
            let viewController = segue.destination as! MoviesDescriptionViewController
            viewController.viewData = self.presenter.parseHomeViewDataToFavoriteViewData(self.viewData.listFavorites[sender as! Int])
        }
    }
}
