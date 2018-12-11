//
//  FavoriteMovie.swift
//  Best Movies
//
//  Created by Vitor Maura on 09/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import Foundation

class FavoriteModel {
    var titleMovie:String?
    var releaseDate:String?
    var urlImage:String?
    var urlPoster:String?
    var description:String?
    var vote_average:Double?
    var isFavorite:Bool?
    var favoriteImage:String?
    var genres:[FavoriteGenre]?
}

class FavoriteGenre {
    var name:String?
}
