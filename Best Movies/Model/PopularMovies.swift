//
//  PopularMovies.swift
//  Best Movies
//
//  Created by Vitor Maura on 04/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import Foundation

class PopularMovies:Codable {
    var page:Int?
    var results:[Movies]?
    var total_results:Int?
    var total_pages:Int?
}

class Movies:Codable {
    var poster_path:String?
    var adult:Bool?
    var overview:String?
    var release_date:String?
    var genre_ids:[Int]?
    var id:Int?
    var original_title:String?
    var original_language:String?
    var title:String?
    var backdrop_path:String?
    var popularity:Double?
    var vote_count:Int?
    var video:Bool?
    var vote_average:Double?
}
