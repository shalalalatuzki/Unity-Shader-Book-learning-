﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 8/Alpha Test"
{
	Properties
	{
		_Color("Color Tint",Color)=(1,1,1,1)
		_Maintex("Main Tex",2D)="white"{}
		_Cutoff("Alpha Cutoff",Range(0,1))=0.5//用于透明度测试的判断条件
	}
	SubShader
	{
		Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}

		Pass
		{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _Maintex;
			float4 _Maintex_ST;
			fixed _Cutoff;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};
			v2f vert(a2v v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				
				o.worldNormal=UnityObjectToWorldNormal(v.normal);
				o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv=TRANSFORM_TEX(v.texcoord,_Maintex);
				return o;
			}
			fixed4 frag(v2f i):SV_TARGET{
				fixed3 worldNormal=normalize(i.worldNormal);
				fixed3 LightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed4 texColor=tex2D(_Maintex,i.uv);

				clip(texColor.a-_Cutoff);

				fixed3 albedo=texColor.rgb*_Color.rgb;
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
				fixed3 diffuse=_LightColor0.rgb*albedo*saturate(dot(worldNormal,LightDir));
				return fixed4(ambient+diffuse,1.0);
			}
			ENDCG
		}
	}
	Fallback "Transparent/Cutout/VertexLit"
}