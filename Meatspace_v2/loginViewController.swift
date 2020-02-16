//
//  ViewController.swift
//  meatspaceProject
//
//  Created by MAC on 2/14/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit
import AVKit
import SwiftyJSON
import CoreData

class loginViewController: UIViewController {
    
    var videolist: [String] = [String]()
    var playerController: AVPlayerViewController?
    
    @IBOutlet  weak var CodeText: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        print("spvdl")
        do {
            let data = try PersistenceService.context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "User")) as! [NSManagedObject]
            if data.count == 0 {
                print("data is 0")
                return
            }
            let token = data[0].value(forKey: "token") as! String
            print("coredata funsiona")
            withtoken(token: token)
        }
        catch {
            print("vdl error")
            return
        }
    }

    @IBOutlet weak var Sincronice: UIButton!
    
    func withtoken(token: String) {
        let response2 = httprequest.send(url:"http://188.76.17.40:63192/api/videolist.php?token=" + token)
        guard let data = response2.data(using: .utf8) else {
            return
        }
        do {
            let json = try JSON(data: data)
            guard let items = json.array else {
                return
            }
            for item in items {
                let urlstr = item["url"].stringValue
                videolist.append(urlstr)
            }
            playvideos()
        }
        catch {
            return
        }
    }
    
    
    
    @IBAction func SincroniceBtnPressed(_ sender: Any){
        
        guard let code = CodeText.text else {
            return;
        }
        
        let response = httprequest.send(url:"http://188.76.17.40:63192/api/check_register_code.php?code=" + code)
        
        if response.count == 0 {
            print("no")
        }
        else {
            print("save aqui")
            if let entity = NSEntityDescription.entity(forEntityName: "User", in:        PersistenceService.context) {
                let user = NSManagedObject(entity: entity, insertInto: PersistenceService.context)
                user.setValue(response, forKey: "token")
                PersistenceService.saveContext()
                print("saved")
                print(response)
            }
            print("save terminado")
            withtoken(token: response)
        }
    }
    
    func playvideos() {
        let urlstr = videolist[Int.random(in: 0 ..< videolist.count)]
        print(urlstr)
        guard let url = URL(string: urlstr) else {
            return
        }
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        playerController = controller
        present(controller, animated: false) {
            player.play()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        if let controller = playerController {
            controller.dismiss(animated: false, completion: {
                self.playvideos()
            })
        }
    }
    

}

