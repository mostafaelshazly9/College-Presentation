//
//  ViewController.swift
//  XO
//
//  Created by Mostafa Elshazly on 4/12/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var xScore: UILabel!
    @IBOutlet weak var yScore: UILabel!
    
    @IBOutlet var tiles: [UIButton]!
    var turn = "X"{
        didSet{
            mainLabel.text = "Player \(turn)'s turn"
        }
    }

    @IBAction func tilePressed(_ sender: UIButton) {
        for tile in tiles{
            if tile.tag == sender.tag{
                updateTile(tile: tile)
            }
        }
        
    }
    
    enum player {
        case X
        case O
    }
    
    var originalColor:UIColor = .blue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalColor = tiles[0].backgroundColor!
    }
    
    func updateTile(tile:UIButton){
        if tile.currentTitle == nil || tile.currentTitle == ""{
            tile.setTitle(turn, for: .normal)
            checkWin()
            switchTurn()
            
        }
    }

    func switchTurn(){
        if turn == "X"{
            turn = "O"
        }else if turn == "O"{
            turn = "X"
        }
    }

    func checkWin(){
        let possibleWins = [(1,2,3),(1,5,9),(1,4,7),(2,5,8),(3,5,7),(3,6,9),(4,5,6),(7,8,9)]
        for combination in possibleWins{
            if compareThree(combination.0,combination.1,combination.2){
                lightUpTiles(combination.0,combination.1,combination.2)
                switch getText(id: combination.0){
                case "X":
                    playerWon(player: .X)
                default:
                    playerWon(player: .O)
                }
            }
        }
    }
    
    func getText(id:Int)->String{
        for tile in tiles{
            if tile.tag == id{
                return tile.currentTitle ?? "Nil"
            }
        }
        print("Error:invalid id")
        return "None"
    }
    
    func getTileByTag(_ tag:Int)->UIButton?{
        for tile in tiles{
            if tile.tag == tag{
                return tile
            }
        }
        print("Error:invalid id")
        return nil

    }

    func compareThree(_ one:Int,_ two:Int, _ three:Int)->Bool{
        return getText(id: one) == getText(id: two) && getText(id: one) == getText(id: three) &&
            getTileByTag(one)?.currentTitle != nil
    }
    
    func lightUpTiles(_ one:Int,_ two:Int, _ three:Int){
        for tileTag in [one,two,three]{
            getTileByTag(tileTag)?.backgroundColor = UIColor.green
        }
    }
    
    func playerWon(player:player){
        for i in 1...9{
            print(i, getText(id: i))
        }

        switch player {
        case .X:
            xScore.text = "\(Int(xScore.text!)! + 1)"
        case .O:
            yScore.text = "\(Int(yScore.text!)! + 1)"
        }
        resetBoard()
    }
    
    func resetBoard(){
        for tile in tiles{
            tile.isEnabled = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            for tile in self.tiles{
                tile.isEnabled = true
                tile.backgroundColor = self.originalColor
                tile.setTitle(nil, for: .normal)
            }
        }
    }
}


