//
//  MovieGenres.swift
//  Best Movies
//
//  Created by Vitor Maura on 10/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import Foundation

class MovieGenres: Codable {
    var genres:[Genres]?
}

class Genres: Codable {
    var id:Int?
    var name:String?
}
