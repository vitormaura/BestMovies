//
//  SLMain.swift
//  Best Movies
//
//  Created by Vitor Maura on 04/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import Foundation
import Alamofire

class MoviesService {
    
    let urlMovies = "https://api.themoviedb.org/3/movie/popular"
    let urlGenres = "https://api.themoviedb.org/3/genre/movie/list"
    let api_Key = "e65a4e0038c43c31f8acd19351a625ba"
    let language =  Locale.current.collatorIdentifier ?? "en-US"
    
    func getMovies(page: Int, completionSuccess: @escaping (_ model:PopularMovies) -> Void, completionError: @escaping (_ error:ErrorType?) -> Void){
        
        Alamofire.request("\(urlMovies)?api_key=\(api_Key)&language=\(language)&page=\(page)").responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.data{
                    do{
                        let movies = try JSONDecoder().decode(PopularMovies.self, from: data)
                        completionSuccess(movies)
                    }catch{
                        completionError(error as? ErrorType)
                    }
                }
            case .failure:
                completionError(ErrorType.generic)
            }
        }
    }
    
    func getGenres(completionSuccess: @escaping (_ model:MovieGenres) -> Void, completionError: @escaping (_ error:ErrorType?) -> Void){
        
        Alamofire.request("\(urlGenres)?api_key=\(api_Key)&language=\(language)").responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.data{
                    do{
                        let genres = try JSONDecoder().decode(MovieGenres.self, from: data)
                        completionSuccess(genres)
                    }catch{
                        completionError(error as? ErrorType)
                    }
                }
            case .failure:
                completionError(ErrorType.generic)
            }
        }
    }
}
