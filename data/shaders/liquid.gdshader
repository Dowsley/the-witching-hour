shader_type canvas_item;
uniform vec4 Color : source_color;
uniform float SurfaceRotation;
uniform float Fill;
uniform sampler2D FillTexture : filter_nearest;
uniform float NoiseScale;
uniform float MinOpacity;


// Rotation2D

void rotation_2d(float angle, vec3 pivot, in vec3 position_in,  out vec3 position_out) {
	mat2 rotation_matrix = mat2( vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
	position_in -= pivot;
	position_out.xy = rotation_matrix * position_in.xy;
	position_out.z = position_in.z;
	position_out += pivot;
	
}
// CelluarNoise3D


// Cellular noise ("Worley noise") in 3D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details.
// https://github.com/stegu/webgl-noise

// Modulo 289 without a division (only multiplications)
vec3 HELPER_CelluarNoise3D_mod289(vec3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

// Modulo 7 without a division
vec3 HELPER_CelluarNoise3D_mod7(vec3 x) {
    return x - floor(x * (1.0 / 7.0)) * 7.0;
}

// Permutation polynomial: (34x^2 + x) mod 289
vec3 HELPER_CelluarNoise3D_permute(vec3 x) {
    return HELPER_CelluarNoise3D_mod289((34.0 * x + 1.0) * x);
}

// Cellular noise, returning F1 and F2 in a vec2.
// 3x3x3 search region for good F2 everywhere, but a lot
// slower than the 2x2x2 version.
// The code below is a bit scary even to its author,
// but it has at least half decent performance on a
// modern GPU. In any case, it beats any software
// implementation of Worley noise hands down.

vec2 cellular_noise_3d(vec3 P, float jitter) {
    float K = 0.142857142857; // 1/7
    float Ko = 0.428571428571; // 1/2-K/2
    float K2 = 0.020408163265306; // 1/(7*7)
    float Kz = 0.166666666667; // 1/6
    float Kzo = 0.416666666667; // 1/2-1/6*2
    
    vec3 Pi = HELPER_CelluarNoise3D_mod289(floor(P));
    vec3 Pf = fract(P) - 0.5;
    
    vec3 Pfx = Pf.x + vec3(1.0, 0.0, -1.0);
    vec3 Pfy = Pf.y + vec3(1.0, 0.0, -1.0);
    vec3 Pfz = Pf.z + vec3(1.0, 0.0, -1.0);
    
    vec3 p = HELPER_CelluarNoise3D_permute(Pi.x + vec3(-1.0, 0.0, 1.0));
    vec3 p1 = HELPER_CelluarNoise3D_permute(p + Pi.y - 1.0);
    vec3 p2 = HELPER_CelluarNoise3D_permute(p + Pi.y);
    vec3 p3 = HELPER_CelluarNoise3D_permute(p + Pi.y + 1.0);
    
    vec3 p11 = HELPER_CelluarNoise3D_permute(p1 + Pi.z - 1.0);
    vec3 p12 = HELPER_CelluarNoise3D_permute(p1 + Pi.z);
    vec3 p13 = HELPER_CelluarNoise3D_permute(p1 + Pi.z + 1.0);
    
    vec3 p21 = HELPER_CelluarNoise3D_permute(p2 + Pi.z - 1.0);
    vec3 p22 = HELPER_CelluarNoise3D_permute(p2 + Pi.z);
    vec3 p23 = HELPER_CelluarNoise3D_permute(p2 + Pi.z + 1.0);
    
    vec3 p31 = HELPER_CelluarNoise3D_permute(p3 + Pi.z - 1.0);
    vec3 p32 = HELPER_CelluarNoise3D_permute(p3 + Pi.z);
    vec3 p33 = HELPER_CelluarNoise3D_permute(p3 + Pi.z + 1.0);
    
    vec3 ox11 = fract(p11*K) - Ko;
    vec3 oy11 = HELPER_CelluarNoise3D_mod7(floor(p11*K))*K - Ko;
    vec3 oz11 = floor(p11*K2)*Kz - Kzo; // p11 < 289 guaranteed
    
    vec3 ox12 = fract(p12*K) - Ko;
    vec3 oy12 = HELPER_CelluarNoise3D_mod7(floor(p12*K))*K - Ko;
    vec3 oz12 = floor(p12*K2)*Kz - Kzo;
    
    vec3 ox13 = fract(p13*K) - Ko;
    vec3 oy13 = HELPER_CelluarNoise3D_mod7(floor(p13*K))*K - Ko;
    vec3 oz13 = floor(p13*K2)*Kz - Kzo;
    
    vec3 ox21 = fract(p21*K) - Ko;
    vec3 oy21 = HELPER_CelluarNoise3D_mod7(floor(p21*K))*K - Ko;
    vec3 oz21 = floor(p21*K2)*Kz - Kzo;
    
    vec3 ox22 = fract(p22*K) - Ko;
    vec3 oy22 = HELPER_CelluarNoise3D_mod7(floor(p22*K))*K - Ko;
    vec3 oz22 = floor(p22*K2)*Kz - Kzo;
    
    vec3 ox23 = fract(p23*K) - Ko;
    vec3 oy23 = HELPER_CelluarNoise3D_mod7(floor(p23*K))*K - Ko;
    vec3 oz23 = floor(p23*K2)*Kz - Kzo;
    
    vec3 ox31 = fract(p31*K) - Ko;
    vec3 oy31 = HELPER_CelluarNoise3D_mod7(floor(p31*K))*K - Ko;
    vec3 oz31 = floor(p31*K2)*Kz - Kzo;
    
    vec3 ox32 = fract(p32*K) - Ko;
    vec3 oy32 = HELPER_CelluarNoise3D_mod7(floor(p32*K))*K - Ko;
    vec3 oz32 = floor(p32*K2)*Kz - Kzo;
    
    vec3 ox33 = fract(p33*K) - Ko;
    vec3 oy33 = HELPER_CelluarNoise3D_mod7(floor(p33*K))*K - Ko;
    vec3 oz33 = floor(p33*K2)*Kz - Kzo;
    
    vec3 dx11 = Pfx + jitter*ox11;
    vec3 dy11 = Pfy.x + jitter*oy11;
    vec3 dz11 = Pfz.x + jitter*oz11;
    
    vec3 dx12 = Pfx + jitter*ox12;
    vec3 dy12 = Pfy.x + jitter*oy12;
    vec3 dz12 = Pfz.y + jitter*oz12;
    
    vec3 dx13 = Pfx + jitter*ox13;
    vec3 dy13 = Pfy.x + jitter*oy13;
    vec3 dz13 = Pfz.z + jitter*oz13;
    
    vec3 dx21 = Pfx + jitter*ox21;
    vec3 dy21 = Pfy.y + jitter*oy21;
    vec3 dz21 = Pfz.x + jitter*oz21;
    
    vec3 dx22 = Pfx + jitter*ox22;
    vec3 dy22 = Pfy.y + jitter*oy22;
    vec3 dz22 = Pfz.y + jitter*oz22;
    
    vec3 dx23 = Pfx + jitter*ox23;
    vec3 dy23 = Pfy.y + jitter*oy23;
    vec3 dz23 = Pfz.z + jitter*oz23;
    
    vec3 dx31 = Pfx + jitter*ox31;
    vec3 dy31 = Pfy.z + jitter*oy31;
    vec3 dz31 = Pfz.x + jitter*oz31;
    
    vec3 dx32 = Pfx + jitter*ox32;
    vec3 dy32 = Pfy.z + jitter*oy32;
    vec3 dz32 = Pfz.y + jitter*oz32;
    
    vec3 dx33 = Pfx + jitter*ox33;
    vec3 dy33 = Pfy.z + jitter*oy33;
    vec3 dz33 = Pfz.z + jitter*oz33;
    
    vec3 d11 = dx11 * dx11 + dy11 * dy11 + dz11 * dz11;
    vec3 d12 = dx12 * dx12 + dy12 * dy12 + dz12 * dz12;
    vec3 d13 = dx13 * dx13 + dy13 * dy13 + dz13 * dz13;
    vec3 d21 = dx21 * dx21 + dy21 * dy21 + dz21 * dz21;
    vec3 d22 = dx22 * dx22 + dy22 * dy22 + dz22 * dz22;
    vec3 d23 = dx23 * dx23 + dy23 * dy23 + dz23 * dz23;
    vec3 d31 = dx31 * dx31 + dy31 * dy31 + dz31 * dz31;
    vec3 d32 = dx32 * dx32 + dy32 * dy32 + dz32 * dz32;
    vec3 d33 = dx33 * dx33 + dy33 * dy33 + dz33 * dz33;
    
    // Sort out the two smallest distances (F1, F2)
/*// F1 only block
    vec3 d1 = min(min(d11,d12), d13);
    vec3 d2 = min(min(d21,d22), d23);
    vec3 d3 = min(min(d31,d32), d33);
    vec3 d = min(min(d1,d2), d3);
    d.x = min(min(d.x,d.y),d.z);
    return vec2(sqrt(d.x)); // F1 duplicated, no F2 computed
//*/// End of F1 only block
//*// F1 and F2 block
    vec3 d1a = min(d11, d12);
    d12 = max(d11, d12);
    d11 = min(d1a, d13); // Smallest now not in d12 or d13
    d13 = max(d1a, d13);
    d12 = min(d12, d13); // 2nd smallest now not in d13
    vec3 d2a = min(d21, d22);
    d22 = max(d21, d22);
    d21 = min(d2a, d23); // Smallest now not in d22 or d23
    d23 = max(d2a, d23);
    d22 = min(d22, d23); // 2nd smallest now not in d23
    vec3 d3a = min(d31, d32);
    d32 = max(d31, d32);
    d31 = min(d3a, d33); // Smallest now not in d32 or d33
    d33 = max(d3a, d33);
    d32 = min(d32, d33); // 2nd smallest now not in d33
    vec3 da = min(d11, d21);
    d21 = max(d11, d21);
    d11 = min(da, d31); // Smallest now in d11
    d31 = max(da, d31); // 2nd smallest now not in d31
    d11.xy = (d11.x < d11.y) ? d11.xy : d11.yx;
    d11.xz = (d11.x < d11.z) ? d11.xz : d11.zx; // d11.x now smallest
    d12 = min(d12, d21); // 2nd smallest now not in d21
    d12 = min(d12, d22); // nor in d22
    d12 = min(d12, d31); // nor in d31
    d12 = min(d12, d32); // nor in d32
    d11.yz = min(d11.yz,d12.xy); // nor in d12.yz
    d11.y = min(d11.y,d12.z); // Only two more to go
    d11.y = min(d11.y,d11.z); // Done! (Phew!)
    return sqrt(d11.xy); // F1, F2
//*/// End of F1 and F2 block
}


void vertex() {
// Output:0

}

void fragment() {
// Texture:36
	vec3 n_out36p0;
	float n_out36p1;
	{
		vec4 _tex_read = texture(TEXTURE , UV.xy);
		n_out36p0 = _tex_read.rgb;
		n_out36p1 = _tex_read.a;
	}

// ColorUniform:2
	vec3 n_out2p0 = Color.rgb;
	float n_out2p1 = Color.a;

// VectorOp:9
	vec3 n_out9p0 = n_out36p0 * n_out2p0;

// ScalarUniform:25
	float n_out25p0 = SurfaceRotation;

// VectorCompose:48
	float n_in48p0 = 0.50000;
	float n_in48p1 = 0.20000;
	float n_in48p2 = 0.00000;
	vec3 n_out48p0 = vec3(n_in48p0, n_in48p1, n_in48p2);

// Input:16
	vec3 n_out16p0 = vec3(UV, 0.0);

// VectorOp:50
	vec3 n_out50p0 = n_out16p0 - n_out48p0;

// ScalarFunc:53
	float n_out53p0 = cos(n_out25p0);

// VectorCompose:52
	float n_in52p1 = 1.00000;
	float n_in52p2 = 1.00000;
	vec3 n_out52p0 = vec3(n_out53p0, n_in52p1, n_in52p2);

// VectorOp:49
	vec3 n_out49p0 = n_out50p0 * n_out52p0;

// VectorOp:51
	vec3 n_out51p0 = n_out49p0 + n_out48p0;

// ScalarUniform:44
	float n_out44p0 = Fill;

// ScalarOp:45
	float n_in45p1 = 1.00000;
	float n_out45p0 = n_out44p0 - n_in45p1;

// VectorCompose:43
	float n_in43p0 = 0.00000;
	float n_in43p2 = 0.00000;
	vec3 n_out43p0 = vec3(n_in43p0, n_out45p0, n_in43p2);

// VectorOp:40
	vec3 n_out40p0 = n_out51p0 + n_out43p0;

// Rotation2D:56
	vec3 n_out56p0;
	{
		rotation_2d(n_out25p0, n_out48p0, n_out40p0, n_out56p0);
	}

// TextureUniform:38
	vec3 n_out38p0;
	float n_out38p1;
	{
		vec4 n_tex_read = texture(FillTexture, n_out56p0.xy);
		n_out38p0 = n_tex_read.rgb;
		n_out38p1 = n_tex_read.a;
	}

// ScalarOp:23
	float n_out23p0 = n_out36p1 * n_out38p1;

// VectorDecompose:59
	float n_out59p0 = n_out16p0.x;
	float n_out59p1 = n_out16p0.y;
	float n_out59p2 = n_out16p0.z;

// Input:14
	float n_out14p0 = TIME;

// ScalarOp:62
	float n_in62p1 = 0.20000;
	float n_out62p0 = n_out14p0 * n_in62p1;

// VectorCompose:60
	vec3 n_out60p0 = vec3(n_out59p0, n_out59p1, n_out62p0);

// ScalarUniform:11
	float n_out11p0 = NoiseScale;

// CelluarNoise3D:61
	float n_in61p2 = 1.00000;
	vec3 n_out61p0;
	float n_out61p1;
	float n_out61p2;
	{
		
			n_out61p0 = vec3(cellular_noise_3d(n_out60p0 * vec3(n_out11p0), n_in61p2), 0.0);
			n_out61p1 = n_out61p0.x;
			n_out61p2 = n_out61p0.y;
			
	}

// ScalarUniform:37
	float n_out37p0 = MinOpacity;

// ScalarClamp:35
	float n_in35p2 = 1.00000;
	float n_out35p0 = clamp(n_out61p1, n_out37p0, n_in35p2);

// ScalarOp:12
	float n_out12p0 = n_out23p0 * n_out35p0;

// Output:0
	COLOR.rgb = n_out9p0;
	COLOR.a = n_out12p0;

}

void light() {
// Output:0

}
