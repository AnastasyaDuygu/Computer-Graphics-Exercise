Shader "Unlit/Ripple"
{
    Properties
    {
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (0,0,0,1)

        _WaveAmp("Wave Amplitude", Range(0,0.2)) = 0.1
        _WaveSpeed("Wave Speed", Float) = 10
        _WaveRepeat("Wave Repeat", Float) = 5
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.2831855

            float4 _ColorA;
            float4 _ColorB;
            float _WaveAmp;
            float _WaveRepeat;
            float _WaveSpeed;


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

            float CreateRipple(float2 uv){ //creates ripple

                float2 uvsCentered = uv * 2 - 1;
                float radialDistance = length ( uvsCentered );
                float t = cos((radialDistance - _Time.y * _WaveSpeed/100) * TAU * _WaveRepeat) * 0.5 + 0.5; // if - _Time then moves in the opposite direction  //* 0.5 + 0.5
                t *= 1 - radialDistance; // gradient
                return t;
            }

            Interpolators vert (MeshData v) // just pass data from vertex shader to fragment shader 
            {
                Interpolators o;

                float ripple = CreateRipple(v.uv0);
                v.vertex.y = ripple * _WaveAmp;

                o.vertex = UnityObjectToClipPos(v.vertex); //local space to clip space
                o.normal = normalize(mul ((float3x3)UNITY_MATRIX_M, v.normals));// when you rotate the sphere normals don't change // //UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float ripple = CreateRipple(i.uv);
                return ripple;
            }
            ENDCG
        }
    }
}
