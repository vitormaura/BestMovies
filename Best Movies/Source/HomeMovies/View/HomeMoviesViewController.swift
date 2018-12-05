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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeMoviesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        UIView.animate(withDuration: 0.4) {
            cell.spruce.animate([.expand(.moderately), .slide(.down, .moderately)])
        }
        return cell
    }
}
