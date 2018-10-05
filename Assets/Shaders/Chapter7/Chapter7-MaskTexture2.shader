Shader "Unity shaders Book/Chapter 7/Mask Texture"
{
	Properties
	{
		_Color("Color Tint",Color)=(1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap("Normal Map",2D)="bump"{}
		_BumpScale("Bump Scale",Float)=1.0
		_SpecularMask("Specular Mask",2D)="white"{}
		_SpecularScale("Specular Scale",Float)=1.0
		_Specular("Specular",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8.0,256))=20
	}
	SubShader
	{
		//Tags { "RenderType"="Opaque" }

		Pass
		{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float _BumpMapScale;
			sampler2D _SpecularMask;
			float4 _Specular;
			float _SpecularScale;
			float _Gloss;
			
			ENDCG	
		}
	}
}