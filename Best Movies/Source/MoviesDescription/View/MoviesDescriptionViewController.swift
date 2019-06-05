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
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelGen: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var favoriteView: LOTAnimationView!
    @IBOutlet weak var loadingPoster: LOTAnimationView!
    @IBOutlet weak var loadingCover: LOTAnimationView!
    
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
        self.presenter.downloadImage(viewData.urlImage, viewData.titleMovie, self.imageCover, self.loadingCover, "errorImage")
        self.presenter.downloadImage(viewData.urlPoster, viewData.description, self.imagePoster, self.loadingPoster, "posterError")
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
    func startLoading(_ loadingView: LOTAnimationView) {
        loadingView.setAnimation(named: "loader")
        loadingView.loopAnimation = true
        loadingView.isHidden = false
        loadingView.play()
    }
    
    func stopLoading(_ loadingView: LOTAnimationView) {
        loadingView.isHidden = true
        loadingView.pause()
    }
    
    func setImageDefault(_ imageView: UIImageView, _ nameDefault:String) {
        if let image = UIImage(named: nameDefault){
            imageView.image = image
        }
    }
    
    func setImage(_ imageView: UIImageView, _ image: UIImage) {
        imageView.image = image
        if self.imagePoster.image == image{
            self.getColors(image: image)
        }
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
    
    func getColors(image: UIImage) {
        image.getColors { (colors) in
            UIView.animate(withDuration: 0.4, animations: {
                self.view.backgroundColor = colors.background
                self.bottomView.backgroundColor = colors.background
                self.textView.backgroundColor = colors.background
                self.navigationController?.navigationBar.barTintColor = colors.background
                self.navigationController?.navigationBar.tintColor = colors.secondary
                self.navigationController?.navigationBar.shadowColor = colors.secondary
                self.setLabelColors(colors)
            })
        }
    }
    
    func setLabelColors(_ colors: UIImageColors) {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BebasKai", size: 27.0)!, NSAttributedString.Key.foregroundColor : colors.detail]
        self.labelNote.textColor = colors.secondary
        self.labelDate.textColor = colors.primary
        self.labelGen.textColor = colors.primary
        self.textDescription.textColor = colors.primary
    }
}
