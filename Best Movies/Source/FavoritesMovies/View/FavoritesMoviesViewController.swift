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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var emptyView: LOTAnimationView!
    @IBOutlet weak var labelEmpty: UILabel!
    
    //MARK: - VARIABLES -
    private var presenter:FavoritesMoviesPresenter!
    private var viewData = ListFavoriteMoviesViewData()
    private var searchMovies = [FavoriteMovieViewData]()
    private var isSearching = false
}
//MARK: - LIFE CYCLE -
extension FavoritesMoviesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = FavoritesMoviesPresenter(viewDelegate: self)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.getFavoriteListDataBase()
        self.setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeLogo()
        self.favoritesTableView.alpha = 1.0
        self.searchBar.text?.removeAll()
    }
}

//MARK: - TABLEVIEW DELEGATE -
extension FavoritesMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticAlerts.hapticReturnLight()
        self.performSegue(withIdentifier: "favoritesSegue", sender: indexPath.row)
    }
}

//MARK: - TABLEVIEW DATASOURCE -
extension FavoritesMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering() ? self.searchMovies.count : self.viewData.listFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FavoriteMovieTableViewCell
        cell.prepare(self.isFiltering() ? self.searchMovies[indexPath.row] : self.viewData.listFavorites[indexPath.row])
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
            self.labelEmpty.text = "You do not have any favorites yet"
        }
    }
}

//MARK: - AUX METHODS -
extension FavoritesMoviesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesSegue" {
            let viewController = segue.destination as! MoviesDescriptionViewController
            let data = self.isFiltering() ? self.searchMovies[sender as! Int] : self.viewData.listFavorites[sender as! Int]
            viewController.viewData = self.presenter.parseHomeViewDataToFavoriteViewData(data)
        }
    }
    
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - SEARCHBAR DELEGATE -
extension FavoritesMoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchMovies = self.viewData.listFavorites.filter({ movie -> Bool in
            movie.titleMovie.lowercased().contains(searchText.lowercased())
        })
        self.setEmpty()
        self.favoritesTableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    func setEmpty(){
        if self.searchMovies.count == 0, self.isFiltering(){
            self.favoritesTableView.alpha = 0.5
            self.emptyView.isHidden = false
            self.emptyView.setAnimation(named: "search")
            self.emptyView.play()
            self.emptyView.loopAnimation = true
            self.labelEmpty.text = "No movies with this name were found"
        }else{
            self.favoritesTableView.alpha = 1.0
            self.emptyView.isHidden = true
            self.emptyView.pause()
        }
    }
    
    func addLogo() {
        let imageLogo = ImageHelper.addNavBarImage(self.navigationController, "favLogo")
        self.navigationController?.navigationBar.addSubview(imageLogo)
    }
    
    func removeLogo() {
        self.navigationController?.navigationBar.subviews.forEach({ (view) in
            guard view is UIImageView else { return }
            view.removeFromSuperview()
        })
    }
    
    func setupNavBar() {
        let purpleColor = UIColor(red: 146/255, green: 0/255, blue: 255/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.layer.shadowColor = purpleColor.cgColor
        self.navBarAppearence()
        self.addLogo()
    }
    
    func navBarAppearence() {
        guard #available(iOS 13.0, *) else { return }
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor.systemBackground
        navBarAppearance.largeTitleTextAttributes =  [NSAttributedString.Key.font: UIFont(name: "BebasKai", size: 27.0)!, NSAttributedString.Key.foregroundColor : UIColor(red: 146/255, green: 0/255, blue: 255/255, alpha: 1.0)]
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
