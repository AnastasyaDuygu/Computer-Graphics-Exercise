Shader "Unlit/FernelShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint("Color", Color) = (1,1,1,1)
        _Gloss("Gloss", Float ) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass // 1st pass is only for directional lighting
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct MeshData
            {
                float2 uv : TEXCOORD0; // uv0 diffuse/normal map textures
                float3 normal : NORMAL;
                float4 vertex : POSITION; 
                //float4 uv1 : TEXCOORD1; // uv1 coordinates lightmap coordinates
                //float4 tangent : TANGENT;
                //float4 color : COLOR;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float3 wPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Gloss;
            float3 _Tint;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal); // when you rotate the sphere normals don't change
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                float3 N = normalize( i.normal ); //to avoid getting visible triangle edges
                float3 L = _WorldSpaceLightPos0.xyz;
                //return float4(L, 1);
                
                //------------------------------------------------
                //Lambertian shading = diffuse lighting
                float3 diffuseLight = saturate(dot(N, L)) * _LightColor0;
                //return float4(diffuseLight, 1);

                //------------------------------------------------
                //Phong shading = specular lighting
                float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
                //float3 R = reflect(-L, N);
                //float3 specularLight = saturate(dot(V, R));

                //specularLight = pow(specularLight, _Gloss); //specular exponent
                //return float4(specularLight, 1);

                //------------------------------------------------
                //Blinn Phong shading = specular lighting
                float3 H = normalize(L + V);
                float3 specularLight = saturate(dot(H, N));

                specularLight = pow(specularLight, _Gloss); //specular exponent
                //return float4(specularLight, 1);

                //Combo
                specularLight *= _LightColor0.xyz;

                float fresnel = (1 - dot(V, N)* 1.5);

                return float4(diffuseLight * _Tint + specularLight + fresnel, 1);
            }
            ENDCG
        }
    }
}
