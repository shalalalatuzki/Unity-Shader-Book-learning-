
// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

Shader "Unity Shaders Book/Chapter9/Shadow2"
{
	Properties
	{
		_Diffuse("Diffuse",Color)=(1,1,1,1)
		_Specular("Specular",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8.0,256))=20
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			Tags { "LightMode"="ForwardBase"}
			CGPROGRAM

			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v
			{
				float4 vertex:POSITION;
				float3 normal:normal;
			}; 
			struct v2f
			{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				SHADOW_COORDS(2)
			};
			v2f vert(a2v v)
			{
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.worldNormal=UnityObjectToWorldNormal(v.normal);
				o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
				TRANSFER_SHADOW(o);
				return o;
			}
			fixed4 frag(v2f i):SV_Target
			{
				fixed3 worldNormal=normalize(i.worldNormal);
				fixed3 lightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));
				//fixed3 lightDir=normalize(_WorldSpaceLightPos0.xyz);
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*max(0,dot(worldNormal,lightDir));

				fixed3 viewDir=normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir=normalize(lightDir+viewDir);
				fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(worldNormal,halfDir)),_Gloss);

				fixed atten=1.0;
				fixed shadow=SHADOW_ATTENUATION(i);
				return fixed4(ambient+(diffuse+specular)*atten*shadow,1.0);
			}
			ENDCG
			
		}
		pass
		{
			Tags { "LightMode"="ForwardAdd"}
			Blend one one
			CGPROGRAM

			#pragma multi_compile_fwdadd
			
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v
			{
				float4 vertex:POSITION;
				float3 normal:normal;
			}; 
			struct v2f
			{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
			};
			v2f vert(a2v v)
			{
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.worldNormal=UnityObjectToWorldNormal(v.normal);
				o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;

				return o;
			}
			fixed4 frag(v2f i):SV_Target
			{

				fixed3 worldNormal=normalize(i.worldNormal);
				#ifdef USING_DTRECTIONAL_LIGHT
					fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));
				#else
					fixed3 worldLightDir=normalize(_WorldSpaceLightPos0.xyz-i.worldPos.xyz);
				#endif
				//fixed3 lightDir=normalize(_WorldSpaceLightPos0.xyz);
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*max(0,dot(worldNormal,worldLightDir));

				fixed3 viewDir=normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir=normalize(worldLightDir+viewDir);
				fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(worldNormal,halfDir)),_Gloss);

				#ifdef USING_DIRECTIONAL_LIGHT
					fixed atten=1.0;
				#else
					#if defined (POINT)
						float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1)).xyz;
				        fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;//将世界空间位置转化到灯光空间后，使用纹理作为查找表得到光源的衰减
					#elif defined (SPOT)//??
						fixed3 lightcoord=mul(unity_WorldToLight,float4(i.worldPos,1)).xyz;
						fixed atten=(lighcoord.z>0)*tex2D(_LightTexture0,lightcoord.xy/lightcoord.w+0.5).w*tex2D(_LightTextureB0,dot(lightcoord,lightcoord).rr).UNITY_ATTEN_CHANNEL;
					#else
						fixed atten=1.0;
				#endif
				#endif
				return fixed4((diffuse+specular)*atten,1.0);
			}
			ENDCG
		}
	}
	Fallback "Specular"
}