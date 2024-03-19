Shader "Unlit/Texture"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct MeshData
            {
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; //clip space position
                float2 uv : TEXCOORD0;
                float3 worldPosition : TEXCOORD1;
            };


            Interpolators vert (MeshData v) // just pass data from vertex shader to fragment shader 
            {
                Interpolators o;
                o.worldPosition = mul (UNITY_MATRIX_M, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex); //local space to clip space
                o.uv = TRANSFORM_TEX(v.uv0, _MainTex);
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float2 topDownProjection = i.worldPosition.xz;
                float4 col = tex2D(_MainTex, topDownProjection);
                return col;
            }
            ENDCG
        }
    }
}
