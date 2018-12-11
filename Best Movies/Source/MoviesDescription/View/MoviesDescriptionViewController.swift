//
//  MoviesDescriptionViewController.swift
//  Best Movies
//
//  Created by Vitor Maura on 07/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit
import Lottie

class MoviesDescriptionViewController: UIViewController {
    
    //MARK: - OUTLETS -
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelGen: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var favoriteView: LOTAnimationView!
    
    //MARK: - VARIABLES -
    private var presenter:MoviesDescriptionPresenter!
    public var viewData = MovieViewData()
    public var genreViewData = MoviesGenresViewData()
}

//MARK: - LIFE CYCLE -
extension MoviesDescriptionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MoviesDescriptionPresenter(viewDelegate: self)
        self.presenter.downloadImage(viewData.urlImage, viewData.titleMovie, self.imageCover)
        self.presenter.downloadImage(viewData.urlPoster, viewData.description, self.imagePoster)
        self.favoriteView.setAnimation(named: "favourite_app_icon")
        self.addTapToFavoriteView()
        self.prepare(viewData)
        self.setFavoriteIcon()
        self.fadeOutImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.subviews[1].removeFromSuperview()
    }
}

//MARK: - MOVIESDESCRIPTION DELEGATE -
extension MoviesDescriptionViewController: MoviesDescriptionDelegate{
    func startLoading() {
        //
    }
    
    func stopLoading() {
        //
    }
    
    func setImageDefault() {
        //
    }
    
    func setImage(_ image: UIImage) {
        //
    }
}

//MARK: - AUX METHODS -
extension MoviesDescriptionViewController {
    func prepare(_ viewData: MovieViewData) {
        title = viewData.titleMovie
        self.labelNote.text = String(viewData.vote_average)
        self.labelDate.text = "Release: \(viewData.releaseDate)"
        self.labelGen.text = viewData.genres.sorted().joined(separator: ", ")
        self.textDescription.text = viewData.description
    }
    
    func fadeOutImage() {
        let mask = CAGradientLayer()
        mask.startPoint = CGPoint(x: 1.0, y: 0.375)
        mask.endPoint = CGPoint(x: 1.0, y: 0.0)
        let whiteColor = UIColor.white
        mask.colors = [whiteColor.withAlphaComponent(0.0).cgColor,whiteColor.withAlphaComponent(1.0),whiteColor.withAlphaComponent(1.0).cgColor]
        mask.locations = [NSNumber(value: 0.0),NSNumber(value: 0.2),NSNumber(value: 1.0)]
        mask.frame = view.bounds
        imagePoster.layer.mask = mask
    }
    
    func addTapToFavoriteView(){
        let tapFavorite = UITapGestureRecognizer(target: self, action: #selector(self.addToFavorites))
        self.favoriteView.addGestureRecognizer(tapFavorite)
    }
    
    @objc func addToFavorites(){
        if !self.presenter.checkFavovite(title: viewData.titleMovie) {
            self.viewData.isFavorite = true
            self.favoriteView.play()
            self.presenter.addOrRemoveFavorite(viewData)
            HapticAlerts.hapticReturnSuccess()
        }else{
            self.viewData.isFavorite = false
            self.favoriteView.stop()
            self.presenter.addOrRemoveFavorite(viewData)
            HapticAlerts.hapticReturnCancel()
        }
    }
    
    func setFavoriteIcon(){
        if self.presenter.checkFavovite(title: viewData.titleMovie){
            self.favoriteView.play()
        }
    }
}
