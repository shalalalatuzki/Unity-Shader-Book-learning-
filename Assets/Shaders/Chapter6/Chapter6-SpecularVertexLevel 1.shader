﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shaders Book/Chapter 6/Specular Vertex-level"{
	Properties{
		_Diffuse ("Diffuse",Color)=(1,1,1,1)
		_Specular ("Specular",Color)=(1,1,1,1)
		_Gloss ("Gloss",Range(8.0,256))=20
	}
	SubShader{
		pass{
			Tags { "LightingMode"="Forwardbase"}
			CGPROGRAM
			#pragma vertex ver
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				fixed3 color:COLOR;
			};
			v2f ver(a2f v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				fixed3 ambient=UNITY_LIGHTMODE_AMBIENT.xyz;
				fixed3 worldNormal=mul(v.normal,(float3x3)unity_WorldToObject);
				fixed3 worldLightDir=normaize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*saturate(mul(worldNormal,worldLightDir));
				fixed3 reflectDir=normalize(reflect(-worldLightDir,worldNormal));
				fixed3 viewDir=normalize(_WorldSpaceCameraPos.xyz-mul(_Object2World,v.vertex));
				fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectDir,viewDir)),_Gloss);
				o.color=ambient+diffuse+specular;

				return o;
			}
			fixed4 frag(v2f i):SV_TARGET{
				return fixed4(i.color,1.0);
			}
			ENDCG 
		}
	}
	Fallback "Specular"
}