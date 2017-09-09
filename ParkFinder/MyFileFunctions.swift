import Foundation
import UIKit
func documentsDirectory() -> URL{
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
}

func tempDirectory()->String{
    return NSTemporaryDirectory()
}

func cachesDirectory()-> URL{
    return FileManager.default.urls(for: .cachesDirectory, in:.userDomainMask).first! as URL
}

extension UIImage{
    func saveImageAsPNG(url:URL){
        let pngData = UIImagePNGRepresentation(self)
        do{
            try pngData?.write(to: url)
        }
        catch{
            print("Error: saving \(url) - error =\(error)")
        }
    }
}
extension FileManager{
    static var documentsDirectory:URL{
        return FileManager.default.urls(for:.documentDirectory, in:.userDomainMask).first! as URL
    }
    static var tempDirectory:URL{
        return FileManager.default.temporaryDirectory
    }
    static var cachesDirectory:URL{
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as URL
    }
    static func filePathInDocumentsDirectory(fileName:String)->URL{
        return FileManager.documentsDirectory.appendingPathComponent(fileName)
    }
    static func fileExistsInDocumentsDirectory(fileName:String)->Bool{
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        return FileManager.default.fileExists(atPath: path)
    }
    static func deleteFileInDocumentsDirectory(fileName:String){
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        do{
            try FileManager.default.removeItem(atPath: path)
            print("File: \(path) was deleted!")
        }
        catch{
            print("Error: \(error) - For file : \(path)")
        }
        
    }
    
    static func contentsOfDir(url:URL)->[String]{
        do{
            if let paths = try FileManager.default.contentsOfDirectory(atPath: url.path) as [String]?{
                return paths
            }
            else{
                print("none found")
                return [String]()
            }
        }
        catch{
            print("Error: \(error)")
            return [String]()
        }
    }
    static func clearDocumentsFolder(){
        let fileManager = FileManager.default
        let docsFolderPath = FileManager.documentsDirectory.path
        do{
            let filePaths = try fileManager.contentsOfDirectory(atPath: docsFolderPath)
            for filePath in filePaths{
                try fileManager.removeItem(atPath:docsFolderPath + "/" + filePath)
            }
            print("cleared documents folder")
        }
        catch{
            print("Could not clear documents folder: \(error)")
        }
    }
    
}
