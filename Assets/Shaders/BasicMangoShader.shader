Shader "Unlit/BasicMango"
{
    Properties
    {
        _Tint("Color", Color) = (1,1,1,1)
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

            float4 _Tint;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct MeshData
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


            Interpolators vert (MeshData v) // just pass data from vertex shader to fragment shader 
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); //local space to clip space
                o.normal = normalize(mul ((float3x3)UNITY_MATRIX_M, v.normals)); // = UnityObjectToWorldNormal(v.normals) // when you rotate the sphere normals don't change
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                return float4(i.normal, 1); // OUTPUT
            }
            ENDCG
        }
    }
}
