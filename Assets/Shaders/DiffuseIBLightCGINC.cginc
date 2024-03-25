            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            #define USE_LIGHTING
            #define TAU 6.28318530718

            struct MeshData
            {
                float2 uv : TEXCOORD0; // uv0 diffuse/normal map textures
                float3 normal : NORMAL;
                float4 vertex : POSITION; 
                //float4 uv1 : TEXCOORD1; // uv1 coordinates lightmap coordinates
                float4 tangent : TANGENT; // w = tangent sign
                //float4 color : COLOR;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float3 wPos : TEXCOORD2;
                float3 tangent : TEXCOORD3; // we can ignore the w component in the vertex shader
                float3 bitangent : TEXCOORD4;
                LIGHTING_COORDS(5,6)
            };

            sampler2D _RockAlbedo;
            float4 _RockAlbedo_ST;
            sampler2D _RockNormals;
            sampler2D _RockHeight;
            float _NormalIntensity;
            float _DisplacementIntensity;
            float _Gloss;
            float3 _Tint;
            float3 _AmbientLight;
            sampler2D _DiffuseIBL;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.uv = TRANSFORM_TEX(v.uv, _RockAlbedo);
                //v.vertex.y += cos(v.uv.x * 8 + _Time.y) *0.05; //wave movement

                //float height = tex2D(_RockHeight, o.uv).x; // btw 0, 1
                float height = tex2Dlod( _RockHeight, float4(o.uv, 0, 0)).x * 2 - 1; // btw -1, 1
                v.vertex.xyz += v.normal * (height * _DisplacementIntensity);
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.normal = UnityObjectToWorldNormal(v.normal); // when you rotate the sphere normals don't change
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                //define direction for tangent space to use Normal Map for texture
                o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
                o.bitangent = cross(o.normal, o.tangent) * (v.tangent.w * unity_WorldTransformParams.w);
                
                TRANSFER_VERTEX_TO_FRAGMENT(o);
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
                #ifdef USE_LIGHTING
                    float3 rock = tex2D(_RockAlbedo, i.uv);
                    float3 surfaceColor = rock * _Tint.rgb;

                    float3 tangentSpaceNormals = UnpackNormal(tex2D(_RockNormals, i.uv));
                    tangentSpaceNormals = normalize(lerp(float3(0,0,1), tangentSpaceNormals, _NormalIntensity));

                    float3x3 tangetToWorldMatrix = {
                        i.tangent.x, i.bitangent.x, i.normal.x,
                        i.tangent.y, i.bitangent.y, i.normal.y,
                        i.tangent.z, i.bitangent.z, i.normal.z,
                    };
                
                    float3 N = normalize(mul(tangetToWorldMatrix, tangentSpaceNormals)); // normalize => to avoid getting visible triangle edges
                    float3 L = normalize( UnityWorldSpaceLightDir(i.wPos));
                    float attenuation = LIGHT_ATTENUATION(i); //reduce strenght of light as it gets further away
                    
                    //Lambertian shading = diffuse lighting
                    float lambert = saturate(dot(N, L));
                    float3 diffuseLight = (lambert * attenuation) * _LightColor0;

                    //DIFFUSE IBL
                    #ifdef IS_IN_BASE_PASS
                        float3 diffuseIBL = tex2Dlod(_DiffuseIBL, float4(DirToRectillinear(N),0,0)).xyz;
                        diffuseLight += diffuseIBL;
                    #endif
                    
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