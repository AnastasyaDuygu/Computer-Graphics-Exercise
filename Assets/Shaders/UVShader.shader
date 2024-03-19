Shader "Unlit/BasicMango"
{
    Properties
    {
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (0,0,0,1)

        _ColorStart("color Start", Range(0,1)) = 0
        _ColorEnd("color End", Range(0,1)) = 1

        _Scale("UV Scale", Float) = 1
        _Offset("UV Diagonal Offset", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.2831855

            float4 _ColorA;
            float4 _ColorB;

            Float _Scale; //Diagonally
            Float _Offset; //Diagonally

            Float _ColorStart;
            Float _ColorEnd;

            struct MeshData // all of them are local space data
            {
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
                //float4 uv1 : TEXCOORD1; // uv1 coordinates lightmap coordinates
                //float4 tangent : TANGENT;
                //float4 color : COLOR;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; //clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v) // just pass data from vertex shader to fragment shader 
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); //local space to clip space
                o.normal = mul ((float3x3)UNITY_MATRIX_M, v.normals); // = UnityObjectToWorldNormal(v.normals) // when you rotate the sphere normals don't change
                o.uv = (v.uv0 + _Offset) * _Scale;
                return o;
            }

            //create own function for InverseLerp

            float InverseLerp(float a, float b, float v){
                return (v-a)/(b-a);
            }

            float CreateTriangleWaves(float coordinates, float repeat){ //Create triangle waves
                //float t = abs(frac(clamped * repeat) * 2 - 1);
                float t = cos(coordinates * TAU * repeat) * 0.5 + 0.5;
                return t;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                // 1: return float4(i.uv, 0, 1); => UV MAP 
                // 2: return float4(i.uv.xxx, 1); => x gradient (black & white)
                // 3: return float4(i.uv.yyy, 1); => y gradient (black & white)

                // 4: float4 outColor = lerp(_ColorA, _ColorB, i.uv.x); //blend btw 2 colors based on the x UV coordinates
                //    return outColor;

                // 5: float t = saturate( InverseLerp(_ColorStart, _ColorEnd, i.uv.x)); // saturate = clamps values of the colors to prevent more than two colors you chose to appear
                //    float4 outColor = lerp(_ColorA, _ColorB, t);
                //    return outColor;

                // 6: float t = saturate( InverseLerp(_ColorStart, _ColorEnd, i.uv.x));
                //    float triangleWaves = CreateTriangleWaves(t, 5);
                //    return lerp(_ColorA, _ColorB, triangleWaves);

                float t = saturate( InverseLerp(_ColorStart, _ColorEnd, i.uv.x));
                float triangleWaves = CreateTriangleWaves(t, 5);
                return lerp(_ColorA, _ColorB, triangleWaves);
                
                
            }
            ENDCG
        }
    }
}
