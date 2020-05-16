// Copyright © 2020 Niklas Buelow. All rights reserved.

import simd
import CoreGraphics

/* The Isometric Axis allow more streamlined and decoupled thinking of the Isometric World Coordinates.
 * Logically the coordinates are retrieved by simple 3D euclidean coordinates. However thinking about
 * the actual placement of a coordinate in the transformed world can make designing for it quite feasible.
 *
 * You can think of the three axis as follows:
 *
 *                      vertical
 *                          |
 *                          |
 *                          |
 *                          x
 *                        /   \
 *                      /       \
 *                    /           \
 *                left             right
 */
public enum IsometricAxis: String {
    /// The matrix for a transformation in 3D space.
    typealias TransformationMatrix = simd_float3x3

    case vertical = "Vertical"
    case right = "Right"
    case left = "Left"

    /// The vectors of each isometric axis in the standard euclidean 3D space.
    var vector: CGVector {
        var axisVector: simd_float3

        switch self {
        case .vertical:
            axisVector = .init(0, 0, 1)

        case .right:
            axisVector = .init(0, 1, 0)

        case .left:
            axisVector = .init(1, 0, 0)
        }

        let transformedVector = simd_mul(axisVector, IsometricAxis.standardToIsoMatrix)
        return CGVector(dx: CGFloat(transformedVector.x), dy: CGFloat(transformedVector.y))
    }

    /// This matrix allows to transform any 3D Vector in the isometric space to the standard space and projecting it at the 2D space.
    static var isoToStandardMatrix: TransformationMatrix {
        let sqrtFactor = sqrtf(3) / 3

        return simd_float3x3(
            simd_float3(-sqrtFactor, -1, 0),
            simd_float3(sqrtFactor, -1, 0),
            simd_float3(0, 0, 0)
        )
    }

    /// This matrix allows to transform any 3D Vector in the standard space to the isometric space and projecting it at the 2D space.
    static var standardToIsoMatrix: TransformationMatrix {
        let cos30: Float = cosf(30 * .pi / 180)
        let cos60: Float = cosf(60 * .pi / 180)

        return simd_float3x3(
            simd_float3(-cos30, cos30, 0),
            simd_float3(-cos60, -cos60, 1),
            simd_float3.zero
        )
    }

    /// This is a helper method to transform a given 2D point by a matrix.
    static func transformed(point: CGPoint, matrix: TransformationMatrix) -> CGPoint {
        let vector = transformed(vector: Vector3D(dx: point.x, dy: point.y, dz: 0), matrix: matrix)
        return CGPoint(x: vector.dx, y: vector.dy)
    }

    /// This is a helper method to transform a given 3D Vector by the supplied matrix.
    static func transformed(vector: Vector3D, matrix: TransformationMatrix) -> Vector3D {
        let simdVector = simd_float3(Float(vector.dx), Float(vector.dy), Float(vector.dz))
        let transformedVector = simd_mul(simdVector, matrix)
        return Vector3D(
            dx: CGFloat(transformedVector.x),
            dy: CGFloat(transformedVector.y),
            dz: CGFloat(transformedVector.z)
        )
    }
}
