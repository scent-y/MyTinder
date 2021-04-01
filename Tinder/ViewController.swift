//
//  ViewController.swift
//  Tinder
//
//  Created by scent-y on 2019/01/08.
//  Copyright © 2019 scent-y. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var basicCard: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!
    
    var centerOfCard:CGPoint!
    var people = [UIView]()
    var selectedCardCount:Int = 0
    
    let name = ["あいこ","かな","さおり","なお","たくや"]
    var likedName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerOfCard = basicCard.center // 最初の初期値をcardOfCenterにだ代入
        people.append(person1)
        people.append(person2)
        people.append(person3)
        people.append(person4)
        people.append(person5)
    }
    
    func resetCard() {
        basicCard.center = self.centerOfCard // 元の位置に戻る
        basicCard.transform = .identity // 角度を元に戻す
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushList" { // segueの特定
            let listView = segue.destination as! ListViewController
            listView.likedName = likedName
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.6, animations: {
            self.resetCard()
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 400, y: self.people[self.selectedCardCount].center.y)
        })
        likeImageView.alpha = 0 // 透明にしている
        likedName.append(name[selectedCardCount])
        selectedCardCount += 1
        
        
        if selectedCardCount >= people.count { // 最後のpeopleのviewのスワイプが完了したとき
            performSegue(withIdentifier: "PushList", sender: self) // sender: 遷移元をViewControllerとしている
        }
        
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.6, animations: {
            self.resetCard()
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 400, y: self.people[self.selectedCardCount].center.y)
        })
        selectedCardCount += 1
        
        likeImageView.alpha = 0
        
        if selectedCardCount >= people.count { // 最後のpeopleのviewのスワイプが完了したとき
            performSegue(withIdentifier: "PushList", sender: self) // sender: 遷移元をViewControllerとしている
        }
    }
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) { // sender : swipeされたときの情報
        let card = sender.view! // view = storyboardのbasicCardのview
        
        let point = sender.translation(in: view) // どれくらいスワイプしたかの位置情報
        
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y) // 元々の座標にスワイプした分の座標を加算している -> ドラッグ & ドロップにあわせてcardの位置が追随される
        people[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y) // カードと一緒にpeopleのviewが追随する
        
        // スワイプに応じてカードの角度を変更する
        let xFromCenter = card.center.x - view.center.x // view.center.x(不変の値）からcardの座標がどれくらい動いたか
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        people[selectedCardCount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        
        if xFromCenter > 0 { // 右にスワイプされたとき
            likeImageView.image = UIImage(named: "good")
            likeImageView.alpha = 1
            likeImageView.tintColor = UIColor.red
        } else if xFromCenter < 0 {
            likeImageView.image = UIImage(named: "bad")
            likeImageView.alpha = 1
            likeImageView.tintColor = UIColor.blue
        }
        
        // カードをタッチして離したとき、初期値に戻す
        if sender.state == UIGestureRecognizer.State.ended { // スワイプが終了したとき
            if card.center.x < 75 { // cardの座標が75より小さいとき（左にスワイプしたとき）
                UIView.animate(withDuration: 0.6, animations: {
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 400, y: self.people[self.selectedCardCount].center.y)
                })
                selectedCardCount += 1

                likeImageView.alpha = 0
                
                if selectedCardCount >= people.count { // 最後のpeopleのviewのスワイプが完了したとき
                    performSegue(withIdentifier: "PushList", sender: self) // sender: 遷移元をViewControllerとしている
                }
                
                return
            } else if card.center.x > self.view.frame.width - 75 {
                UIView.animate(withDuration: 0.6, animations: {
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 400, y: self.people[self.selectedCardCount].center.y)
                })
                likeImageView.alpha = 0
                likedName.append(name[selectedCardCount])
                selectedCardCount += 1
                
                
                if selectedCardCount >= people.count { // 最後のpeopleのviewのスワイプが完了したとき
                    performSegue(withIdentifier: "PushList", sender: self) // sender: 遷移元をViewControllerとしている
                }
                
                return
            }
            
            // カードの位置を初期値に戻す
            UIView.animate(withDuration: 0.3, animations: {
                // 0.3秒間でこのアニメーションを実行する
                self.resetCard()
                self.people[self.selectedCardCount].center = self.centerOfCard
                self.people[self.selectedCardCount].transform = .identity
            })
            self.likeImageView.alpha = 0
        }

        
    }
    

}

