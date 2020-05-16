// Copyright © 2020 Niklas Buelow. All rights reserved.

import CoreGraphics

extension CGVector {
    /**
     * Multiplies the vector by a scalar. So it is stretched by the scalar in each direction.
     */
    func multiplied(by scalar: CGFloat) -> CGVector {
        return CGVector(dx: scalar * dx, dy: scalar * dy)
    }

    /**
     * Calculates the Euclidean Norm of the Vector. The Euclidean Norm is in this case equivalent to the Pythagorean theorem.
     */
    func euclideanNorm() -> CGFloat {
        return hypot(dx, dy)
    }

    /**
     * Calculates the smalles angle between this vector and a second vector. This value is bound by 0 and pi.
     */
    func angleInRadians(_ second: CGVector) -> CGFloat {
        return acos(CGVector.dotProduct(self, second) / (euclideanNorm() * second.euclideanNorm()))
    }

    /**
     * Calculates the dot product of two two dimensional vectors.
     */
    static func dotProduct(_ lhs: CGVector, _ rhs: CGVector) -> CGFloat {
        return lhs.dx * rhs.dx + lhs.dy * rhs.dy
    }
}
