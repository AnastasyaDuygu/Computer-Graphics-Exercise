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
            float _Gloss;
            float3 _Tint;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _RockAlbedo);
                o.normal = UnityObjectToWorldNormal(v.normal); // when you rotate the sphere normals don't change
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                //define direction for tangent space to use Normal Map for texture
                o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
                o.bitangent = cross(o.normal, o.tangent) * (v.tangent.w * unity_WorldTransformParams.w);
                
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                #ifdef USE_LIGHTING
                    //if USE_LIGHTING is defined do this
                    float3 rock = tex2D(_RockAlbedo, i.uv);
                    float3 surfaceColor = rock * _Tint.rgb;

                    float3 tangentSpaceNormals = UnpackNormal(tex2D(_RockNormals, i.uv));
                    //return float4(unpackedNormals,0);

                    float3x3 tangetToWorldMatrix = {
                        i.tangent.x, i.bitangent.x, i.normal.x,
                        i.tangent.y, i.bitangent.y, i.normal.y,
                        i.tangent.z, i.bitangent.z, i.normal.z,
                    };
                
                    //float3 N = normalize( i.normal ); //to avoid getting visible triangle edges
                    float3 N = mul(tangetToWorldMatrix, tangentSpaceNormals);

                        
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