//
//  ViewController.swift
//  WhereDoesTheQueenGoes?
//
//  Created by G4B0 CU4DR05_C4RD3N4S on 2019/11/29.
//  Copyright © 2019 Gabo-TheCreator. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var xAndyLenght = 10
    var linearMatrix : [Bool?] = []
    let firstPositionOfTheQueen = 99
    var firstValueOfTheQueen = 0

    var positionMatrix : [[Int]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firstValueOfTheQueen = firstPositionOfTheQueen + 1
        linearMatrix = setFirstPosition(position: firstPositionOfTheQueen,
                                        matrix: createMatrix(size: xAndyLenght))
        positionMatrix = createPositionMatrix(size: xAndyLenght)
        
        looper(valueOfTheQueen: firstValueOfTheQueen)
    }
    
    func looper (valueOfTheQueen: Int) {
        applyChangesDependingOnNewQueen(newQueenWithValue: valueOfTheQueen,
                                        matrix: linearMatrix,
                                        positionMatrix: positionMatrix) { (result) in
                                            if let nextPosition = searchForNextNilPosition(linearMatrix: result) {
                                                looper(valueOfTheQueen: nextPosition + 1)
                                            } else {
                                                print("All the queen positions are:")
                                                print(getTruePositions(linearMatrix: linearMatrix))
                                            }
        }
    }
    
    func searchForNextNilPosition (linearMatrix : [Bool?]) -> Int? {
        let matrix = linearMatrix
        for (position, value) in matrix.enumerated() {
            if value == nil {
                return position
            }
        }
        
        return nil
    }

    func getTruePositions (linearMatrix : [Bool?]) -> [Int] {
        let matrix = linearMatrix
        var trueValues : [Int] = []
        
        for (position, value) in matrix.enumerated() {
            if value == true {
                trueValues.append(position + 1)
            }
        }
        
        return trueValues
    }

    func createMatrix (size: Int) -> [Bool?] {
        let squareSize = size * size
        for _ in 1...squareSize {
            linearMatrix.append(nil)
        }
        return linearMatrix
    }

    func createPositionMatrix (size: Int) -> [[Int]] {
        for i in 0..<size {
            var insideArray : [Int] = []
            
            let posicionPorVuelta = i * size
            
            for a in 1...size {
                insideArray.append(posicionPorVuelta + a)
            }
            print(insideArray)
            
            positionMatrix.append(insideArray)
        }
        
        return positionMatrix
    }

    func setFirstPosition (position: Int, matrix: [Bool?]) -> [Bool?] {
        var newMatrix = matrix
        newMatrix[position] = true
        return newMatrix
    }


    func applyChangesDependingOnNewQueen (newQueenWithValue: Int, matrix : [Bool?], positionMatrix : [[Int]], completionHandler: (_ result: [Bool?]) -> Void) {
        
        // Set true this Queen
        var matrixAfterTrue = matrix
        matrixAfterTrue[newQueenWithValue - 1] = true
        
        // Search For Line
        let matrixAfterLineModified = invalidateValuesInLinearMatrix(valuesToInvalidate: searchForLineValues(queenWithValue: newQueenWithValue,
                                                                                                             positionMatrix: positionMatrix),
                                                                     linearMatrix: matrixAfterTrue)
        
        
        // Search For Column
        let matrixAfterColumnModified = invalidateValuesInLinearMatrix(valuesToInvalidate: searchForColumnValues(queenWithValue: newQueenWithValue,
                                                                                                                 positionMatrix: positionMatrix),
                                                                       linearMatrix: matrixAfterLineModified)
        
        // Search for Diagonals
        let matrixAfterDiagonalModified = invalidateValuesInLinearMatrix(valuesToInvalidate: searchForDiagonals(queenWithValue: newQueenWithValue,
                                                                                                                positionMatrix: positionMatrix),
                                                                         linearMatrix: matrixAfterColumnModified)
        
        linearMatrix = matrixAfterDiagonalModified
        
        completionHandler(matrixAfterDiagonalModified)
    }
    
    func invalidateValuesInLinearMatrix (valuesToInvalidate : [Int], linearMatrix: [Bool?]) -> [Bool?] {
        var matrix = linearMatrix
        for value in valuesToInvalidate {
            let position = value - 1
            if matrix[position] == nil {
                matrix[position] = false
            }
        }
        
        return matrix
    }

    func searchForLineValues (queenWithValue: Int, positionMatrix : [[Int]]) -> [Int] {
        for inArr in positionMatrix {
            for value in inArr {
                if queenWithValue == value {
                    return inArr
                }
            }
        }
        
        return []
    }

    func searchForColumnValues (queenWithValue: Int, positionMatrix : [[Int]]) -> [Int] {
        
        for inArr in positionMatrix {
            for i in 0..<inArr.count {
                if queenWithValue == inArr[i] {
                    var valuesToReturn : [Int] = []
                    for internalArr in positionMatrix {
                        valuesToReturn.append(internalArr[i])
                    }
                    return valuesToReturn
                }
            }
        }
        
        return []
    }

    func searchForDiagonals (queenWithValue: Int, positionMatrix : [[Int]]) -> [Int] {
        
        for linePosition in 0..<positionMatrix.count {
            let inArr = positionMatrix[linePosition]
            for columnPosition in 0..<inArr.count {
                let value = inArr[columnPosition]
                if queenWithValue == value {
                    
                    var returnValues : [Int] = []
                    for matrixLinePositions in 0..<positionMatrix.count {
                        let lineDiference = abs(matrixLinePositions - linePosition)
                        for values in returnDiagonalFromDiferenceAndPosition(array: positionMatrix[matrixLinePositions], position: columnPosition, diference: lineDiference) {
                            returnValues.append(values)
                        }
                    }
                    return returnValues
                }
            }
        }
        return []
    }

    func returnDiagonalFromDiferenceAndPosition (array: [Int], position : Int, diference: Int) -> [Int] {
        
        var returnArray : [Int] = []
        
        if array.indices.firstIndex(of: position - diference) != nil {
            if let value = array[position - diference] as? Int {
                returnArray.append(value)
            }
        }
        
        if array.indices.firstIndex(of: position + diference) != nil {
            if let value = array[position + diference] as? Int {
                returnArray.append(value)
            }
        }
        
        return returnArray
    }
    
}

