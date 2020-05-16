// Copyright © 2020 Niklas Buelow. All rights reserved.

import CoreGraphics
import simd

/// A Vector3D is as it names suggests a 3D Vector.
/// However it tries to abstract the vector of the SIMD framework.
struct Vector3D {
    var dx: CGFloat
    var dy: CGFloat
    var dz: CGFloat

    /// Converts the vector to its SIMD vector equivalent.
    func toSimd() -> simd_float3 {
        simd_float3(Float(dx), Float(dy), Float(dz))
    }

    /// Projects the vector onto 2D space.
    func project2D() -> CGPoint {
        return CGPoint(x: dx, y: dy)
    }
}
