//
//  MoviesTVDescriptionViewController.swift
//  Best Movies TV
//
//  Created by Vitor Maura on 05/02/19.
//  Copyright © 2019 Vitor Maura. All rights reserved.
//

import UIKit
import Lottie

class MoviesTVDescriptionViewController: UIViewController {
    
    //MARK: - OUTLETS -
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelGen: UILabel!
    @IBOutlet weak var labelTitleGen: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var loadingView: LOTAnimationView!
    
    
    //MARK: - VARIABLES -
    private var presenter:MoviesTVDescriptionPresenter!
    public var viewData = MovieViewData()
    public var genreViewData = MoviesGenresViewData()
}

//MARK: - LIFE CYCLE -
extension MoviesTVDescriptionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MoviesTVDescriptionPresenter(viewDelegate: self)
        self.presenter.downloadImage(viewData.urlImage, viewData.description, self.imagePoster, self.loadingView, "errorImage")
         self.presenter.downloadImage(viewData.urlPoster, viewData.description, self.imageCover, self.loadingView, "errorImage")
        self.prepare(viewData)
        self.fadeOutImage()
        self.setupTextView()
    }
}

//MARK: - MOVIESDESCRIPTION DELEGATE -
extension MoviesTVDescriptionViewController: MoviesTVDescriptionDelegate{
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
        guard let image = UIImage(named: nameDefault) else { return }
        imageView.image = image
    }
    
    func setImage(_ imageView: UIImageView, _ image: UIImage) {
        imageView.image = image
        guard self.imageCover.image == image else { return }
        self.getColors(image: image)
    }
}

//MARK: - AUX METHODS -
extension MoviesTVDescriptionViewController {
    func prepare(_ viewData: MovieViewData) {
        self.labelTitle.text = viewData.titleMovie
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
        self.imageCover.layer.mask = mask
    }
    
    func setupTextView() {
        self.textDescription.isUserInteractionEnabled = true;
        self.textDescription.isScrollEnabled = true;
        self.textDescription.showsVerticalScrollIndicator = true;
        self.textDescription.bounces = true;
        self.textDescription.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
    }
    
    func getColors(image: UIImage) {
        image.getColors { (colors) in
            UIView.animate(withDuration: 0.4, animations: {
                self.view.backgroundColor = colors.background
                self.setLabelColors(colors)
            })
        }
    }
    
    func setLabelColors(_ colors: UIImageColors) {
        self.labelTitle.textColor = colors.detail
        self.labelNote.textColor = colors.secondary
        self.labelDate.textColor = colors.primary
        self.labelGen.textColor = colors.primary
        self.labelTitleGen.textColor = colors.secondary
        self.textDescription.textColor = colors.primary
    }
}
