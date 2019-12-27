//
//  Matrix.swift
//  My Quotes
//
//  Created by Manthan Vanani on 27/12/19.
//  Copyright © 2019 Manthan Vanani. All rights reserved.
//

import Foundation
import UIKit

func transpose(_ matrix: [[Double]]) -> [[Double]] {
    let rowCount = matrix.count
    let colCount = matrix[0].count
    var transposed : [[Double]] = Array(repeating: Array(repeating: 0.0, count: rowCount), count: colCount)
    for rowPos in 0..<matrix.count {
        for colPos in 0..<matrix[0].count {
            transposed[colPos][rowPos] = matrix[rowPos][colPos]
        }
    }
    return transposed
}

 
func multiply(_ A: [[Double]], _ B: [[Double]]) -> [[Double]] {
    let rowCount = A.count
    let colCount = B[0].count
    var product : [[Double]] = Array(repeating: Array(repeating: 0.0, count: colCount), count: rowCount)
    for rowPos in 0..<rowCount {
        for colPos in 0..<colCount {
            for i in 0..<B.count {
                product[rowPos][colPos] += A[rowPos][i] * B[i][colPos]
            }
        }
    }
    return product
}
 
// gauss jordan inversion
func inverse(_ matrix: [[Double]]) -> [[Double]] {
    // augment matrix
    var matrix = matrix
    var idrow = Array(repeating: 0.0, count: matrix.count)
    idrow[0] = 1.0
    for row in 0..<matrix.count {
        matrix[row] += idrow
        idrow.insert(0.0, at:0)
        idrow.removeLast()
    }
    
    // partial pivot
    for row1 in 0..<matrix.count {
        for row2 in row1..<matrix.count {
            if abs(matrix[row1][row1]) < abs(matrix[row2][row2]) {
                (matrix[row1],matrix[row2]) = (matrix[row2],matrix[row1])
            }
        }
    }
    
    // forward elimination
    for pivot in 0..<matrix.count {
        // multiply
        let arg = 1.0 / matrix[pivot][pivot]
        for col in pivot..<matrix[pivot].count {
            matrix[pivot][col] *= arg
        }
        
        // multiply-add
        for row in (pivot+1)..<matrix.count {
            let arg = matrix[row][pivot] / matrix[pivot][pivot]
            for col in pivot..<matrix[row].count {
                matrix[row][col] -= arg * matrix[pivot][col]
            }
        }
    }
    
    // backward elimination
    for pivot in (0..<matrix.count).reversed() {
        // multiply-add
        for row in 0..<pivot {
            let arg = matrix[row][pivot] / matrix[pivot][pivot]
            for col in pivot..<matrix[row].count {
                matrix[row][col] -= arg * matrix[pivot][col]
            }
        }
    }
    
    // remove identity
    for row in 0..<matrix.count {
        for _ in 0..<matrix.count {
            matrix[row].remove(at:0)
        }
    }
    
    return matrix
}
 
