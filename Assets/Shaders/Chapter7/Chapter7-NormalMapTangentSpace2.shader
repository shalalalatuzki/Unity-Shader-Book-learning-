// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 7/Normal Map In Tangent Space 2"
{
	Properties
	{
		_Color("Color Tint",Color)=(1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap("Normal Map",2D)="bump"{}//内置的法线纹理
		_BumpScale("Bump Scale",Float)=1.0//用于控制凹凸程度
		_Specular("Specular",Color)=(1,1,1,1)
		_Specular("Gloss",Range(8.0,256))=20
	}
	SubShader
	{
		Pass
		{
			Tags{"LightMode"="Forwardbase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
				float4 texcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				float4 uv:TEXCOORD0;//使用了两张纹理，需要存储两个纹理坐标。xy分量存储了maintex的纹理坐标，zw存储了bumpmap的纹理坐标
				float3 lightDir:TEXCOORD1;
				float3 viewDir:TEXCOORD2;
			};
			v2f vert(a2v v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);

				o.uv.xy=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
				o.uv.zw=v.texcoord.xy*_BumpMap_ST.xy+_BumpMap_ST.zw;

				TANGENT_SPACE_ROTATION;//unity中的内置宏，直接得到模型空间到法线空间的变换rotation矩阵
				o.lightDir=mul(rotation,ObjSpaceLightDir(v.vertex)).xyz;
				o.viewDir=mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;
				return  o;
			}
			fixed4 frag(v2f i):SV_TARGET
			{
				fixed3 tangentLightDir=normalize(i.lightDir);
				fixed3 tangentViewDir=normalize(i.viewDir);
				//计算原始法线的坐标信息，纹理的法线坐标是像素坐标，要转成原始的顶点坐标。
				fixed4 packedNormal=tex2D(_BumpMap,i.uv.zw);
				fixed3 tangentNormal;
				tangentNormal=UnpackNormal(packedNormal);
				tangentNormal.xy*=_BumpScale;
				tangentNormal.z=sqrt(1.0-saturate(dot(tangentNormal.xy,tangentNormal.xy)));

				fixed3 albedo=tex2D(_MainTex,i.uv).rgb*_Color.rgb;//使用纹理采样的rgb与材质颜色的乘积作为反射率
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
				fixed3 diffuse=_LightColor0.rgb*albedo*max(0,dot(tangentNormal,tangentLightDir));//使用切线空间计算

				fixed3 halfDir=normalize(tangentViewDir+tangentNormal);//使用切线空间计算
				fixed3 specular=_LightColor0.rgb*_Specular*pow(max(0,dot(tangentNormal,halfDir)),_Gloss);
				return fixed4(ambient+diffuse+specular,1.0);

			}
			ENDCG	
		}
	}
	Fallback "Specular"
}