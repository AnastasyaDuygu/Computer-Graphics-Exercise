            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            #define USE_LIGHTING
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
                LIGHTING_COORDS(3,4)
            };

            sampler2D _RockAlbedo;
            float4 _RockAlbedo_ST;
            float _Gloss;
            float3 _Tint;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _RockAlbedo);
                o.normal = UnityObjectToWorldNormal(v.normal); // when you rotate the sphere normals don't change
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                float3 rock = tex2D(_RockAlbedo, i.uv);
                float3 surfaceColor = rock * _Tint.rgb;
                #ifdef USE_LIGHTING
                    //if USE_LIGHTING is defined do this
                    float3 N = normalize( i.normal ); //to avoid getting visible triangle edges
                    float3 L = normalize( UnityWorldSpaceLightDir(i.wPos));
                    float attenuation = LIGHT_ATTENUATION(i); //reduce strenght of light as it gets further away
                    
                    //Lambertian shading = diffuse lighting
                    float lambert = saturate(dot(N, L));
                    float3 diffuseLight = (lambert * attenuation) * _LightColor0;
                    
                    //Phong shading = specular lighting
                    float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
                    
                    //Blinn Phong shading = specular lighting
                    float3 H = normalize(L + V);
                    float3 specularLight = saturate(dot(H, N)) * attenuation;

                    specularLight = pow(specularLight, _Gloss); //specular exponent

                    //Combination Specular + Diffuse
                    specularLight *= _LightColor0.xyz;

                    return float4(diffuseLight * surfaceColor + specularLight, 1);
                #else
                    //else do this
                    #ifdef IS_IN_BASE_PASS
                        return float4(surfaceColor,0);
                    #else
                        return 0; //so that secondary light sources dont create an additive/ white surface
                    #endif
                #endif
                
                
            }