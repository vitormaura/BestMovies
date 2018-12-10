//
//  FavoriteManager.swift
//  Best Movies
//
//  Created by Vitor Maura on 09/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import CoreData

class FavoriteManager:MainCoreData {
    private var fetchRequest:NSFetchRequest<FavoriteMovieDatabase> = FavoriteMovieDatabase.fetchRequest()
    private var sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
}

extension FavoriteManager{
    func createOrRemoveFavoriteDataBase(model:FavoriteModel){
        if let favoriteResult = self.getFavorite(title: model.titleMovie ?? ""){
            self.removeFavoriteDataBase(favoriteResult)
        }else{
            self.parseFavoriteModelFromDataBase(model)
        }
    }
    
    func removeFavoriteDataBase(model:FavoriteModel){
        if let favoriteResult = self.getFavorite(title: model.titleMovie ?? ""){
            self.removeFavoriteDataBase(favoriteResult)
        }
    }
    
    func fetchFavoriteDataBase(title: String) -> FavoriteModel?{
        if let favoriteDataBase = self.getFavorite(title: title){
            return self.parseFavoriteDataBaseFromModel(dataBase: favoriteDataBase)
        }
        return nil
    }
    
    func fetchListFavoriteDataBase() -> [FavoriteModel]?{
        if let favoriteListDataBase = self.getFavoriteList(), favoriteListDataBase.count > 0{
            var list = [FavoriteModel]()
            for favoriteRow in favoriteListDataBase{
                list.append(self.parseFavoriteDataBaseFromModel(dataBase: favoriteRow))
            }
            return list
        }
        return nil
    }
    
    func checkFavoriteDataBase(title: String) -> Bool{
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.sortDescriptors = [self.sortDescriptor]
        do {
            let result = try self.context.fetch(self.fetchRequest)
            if result.first != nil{
                return true
            }
        } catch {
            return false
        }
        return false
    }
}

extension FavoriteManager{
    private func getFavorite(title: String) -> FavoriteMovieDatabase?{
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.sortDescriptors = [self.sortDescriptor]
        do {
            let result = try self.context.fetch(self.fetchRequest)
            if let favoriteDb = result.first{
                return favoriteDb
            }
        } catch {
            return nil
        }
        return nil
    }
    
    private func getFavoriteList() -> [FavoriteMovieDatabase]?{
        do {
            return try self.context.fetch(self.fetchRequest)
        } catch {
            return nil
        }
    }
    
    private func removeFavoriteDataBase(_ dataBase:FavoriteMovieDatabase){
        self.context.delete(dataBase)
        do {
            try self.saveDatabase()
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension FavoriteManager{
    private func parseFavoriteModelFromDataBase(_ model:FavoriteModel){
        let favoriteDataBase = FavoriteMovieDatabase(context: self.context)
        favoriteDataBase.title = model.titleMovie ?? ""
        favoriteDataBase.descriptionMovie = model.description ?? ""
        favoriteDataBase.date = model.releaseDate ?? ""
        favoriteDataBase.urlCover = model.urlImage ?? ""
        favoriteDataBase.urlPoster = model.urlPoster ?? ""
        favoriteDataBase.genIDs = model.gen_ids ?? 0
        favoriteDataBase.note = model.vote_average ?? 0.0
        favoriteDataBase.isFavorite = model.isFavorite ?? false
        favoriteDataBase.favoriteImage = model.favoriteImage ?? ""
        do {
            try self.saveDatabase()
        } catch  {
            print(error)
        }
    }
    
    private func parseFavoriteDataBaseFromModel(dataBase:FavoriteMovieDatabase) -> FavoriteModel{
        let favoriteModel = FavoriteModel()
        favoriteModel.titleMovie = dataBase.title
        favoriteModel.description = dataBase.descriptionMovie
        favoriteModel.releaseDate = dataBase.date
        favoriteModel.urlImage = dataBase.urlCover
        favoriteModel.urlPoster = dataBase.urlPoster
        favoriteModel.gen_ids = dataBase.genIDs
        favoriteModel.vote_average = dataBase.note
        favoriteModel.isFavorite = dataBase.isFavorite
        favoriteModel.favoriteImage = dataBase.favoriteImage
        return favoriteModel
    }
    
}

