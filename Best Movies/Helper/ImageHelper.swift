//
//  ImageHelper.swift
//  Best Movies
//
//  Created by Vitor Maura on 09/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit

class ImageHelper {
    class func addNavBarImage(_ navController: UINavigationController?, _ imageName: String) -> UIView{
        guard let navController = navController else { return UIView() }
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: 240, height: 60)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
