//
//  ConfigFile.swift
//  likeOrDislike
//
//  Created by hanif hussain on 23/10/2023.
//

import Foundation
import UnsplashFramework
import UIKit


class CardImages {
    var photoID = [String]()
    var photoData = [UNPhoto]()
    var pictures = [UIImage]()
    let configData = ConfigFile()
    let credentials: UNCredentials
    let client: UNClient
    
    var fm = FileManager.default
    var path = Bundle.main.resourcePath!
    
    var RemovalID = [String]()
    
    weak var delegate: SwipeCardViewController!

    
    init() {
        // initialise and connect to Unsplash API using credentials 
        credentials = UNCredentials(accessKey: configData.apiAccessKey, secret: configData.apiSecretKey)
        client = UNClient(with: credentials)
        createFolderInDocumentDirectory()
        Task {
            await getImageURLS()
            await loadImages()
            // now we download the images that are not stored
            for i in photoData {
                // start downloading images, modify the i.imagesURLs.regularURL to change image quality
                try? await download(url: i.imageURLs.regularURL, id: i.id)
            }
        }
    }
    
    func loadImages() async {
        // initiate loading of files by specifying to look in the document directory folder/ images
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = FileManager.default.urls(for: documentDirectory, in: userDomainMask)
        let customImagesFolderURL = paths[0].appendingPathComponent("Images")
        
        // iterate over the photoID and if it matches the one in our document directory then append to our photos array and add the ID to removal list array so we can remove it from the download list
        for id in photoID {
            let imageUrl = URL(fileURLWithPath: customImagesFolderURL.path()).appendingPathComponent(id)
            guard let image = UIImage(contentsOfFile: imageUrl.path) else { return }
            pictures.append(image)
            RemovalID.append(id)
        }
        
        // remove images that are already downloaded
        for x in RemovalID {
            for (index, item) in photoData.enumerated() {
                if item.id == x {
                    photoData.remove(at: index)
                    photoID.remove(at: index)
                }
            }
        }
        // refresh the card view
        await delegate.loadImages(pics: pictures)
    }
    
    func getImageURLS() async {
        // Searching photos
        let photos = try? await client.searchPhotos(query: "forest", pageNumber: 1, photosPerPage: 50, orderedBy: .relevance)
        
        // store the image properties (we are not dowloading yet as we want to check if image exists already to save user data allowance)
        for i in photos!.elements {
            //let url = i.imageURLs.regularURL
            photoID.append("\(i.id).jpeg")
            photoData.append(i)
        }
        
    }
    
    // Fetch photo with async/await
    func download(url: URL, id: String) async throws {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return
        }
        
        // get image from data else return
        guard let image = UIImage(data: data) else {
            return
        }
        
        // uncomment the code below to save to document directory, I'm not saving at the moment due to phone space limitation
//        DispatchQueue.global().async {
//            self.saveImage(image, id: id)
//        }
        
        self.pictures.append(image)
        
        // reload the card data
        await delegate.loadImages(pics: pictures)
        
    }
    
    func saveImage(_ image: UIImage?, id: String) {
        let imageStorePath = getDocumentsDirectory().appendingPathComponent("\(id).jpeg")
        if let image = image {
            // convert image to image data for local storage
            if let data = image.jpegData(compressionQuality: 0.8) {
                // write image to disk
                try? data.write(to: imageStorePath)
                
            }
        } else {
            try? FileManager.default.removeItem(at: imageStorePath)
        }
    }
    
    func createFolderInDocumentDirectory() {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dirURL = documentDirectory.appendingPathComponent("Images")
        do
        {
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: false, attributes: nil)
        }
        catch let error as NSError
        {
            print("Unable to create directory")
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first
        let imagesFolder = documentsDirectory?.appending(path: "Images")
        
        // let path = documentsDirectory.appending(path: "Images")
        return imagesFolder!
        
        // just send back the first one, which ought to be the only one
    }
}

