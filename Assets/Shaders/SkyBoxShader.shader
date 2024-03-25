Shader "Unlit/SkyBoxShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint("Color", Color) = (1,1,1,1)
        //..., Range (0,1) = 1
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

            #define TAU 6.28318530718

            struct MeshData
            {
                float3 uv : TEXCOORD0; // uv0 diffuse/normal map textures
                float3 normal : NORMAL;
                float4 vertex : POSITION; 
                //float4 uv1 : TEXCOORD1; // uv1 coordinates lightmap coordinates
                //float4 tangent : TANGENT;
                //float4 color : COLOR;
            };

            struct Interpolators
            {
                float3 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = normalize(mul((float3x3)UNITY_MATRIX_M, v.normal)); // UnityObjectToWorldNormal(v.normals) // when you rotate the sphere normals don't change
                return o;
            }

            float2 DirToRectillinear ( float3 dir )
            {
                float x = atan2 (dir.z, dir.x) / TAU + 0.5; // btw 0,1
                float y = dir.y * 0.5 + 0.5; // btw 0, 1
                return float2(x,y);
            }            
            float4 frag(Interpolators i) : SV_Target
            {
                //float4 mainTex = tex2D(_MainTex,DirToRectillinear(i.uv));
                float4 mainTex = tex2Dlod(_MainTex,float4(DirToRectillinear(i.uv),0,0)); //hack to get rid of seam
                return mainTex;
            }
            ENDCG
        }
    }
}
