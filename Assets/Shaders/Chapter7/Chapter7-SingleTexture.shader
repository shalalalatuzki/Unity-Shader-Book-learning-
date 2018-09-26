// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 7/Single Text"
{
	Properties
	{
		_Color("Color Tint",Color)=(1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Specular("Specular",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8.0,256))=20
	}
	SubShader
	{
		Pass
		{
			Tags{"Lighting"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Specular;
			float _Gloss;

			struct a2v{
				float4 vertex:Position;
				float3 normal:NORMAL;
				float4 textcoord:TEXCOORD0;
			};
			struct v2f{
				float4 pos :SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXTCOORD2;
			};
			v2f vert(a2v v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.worldNormal=UnityObjectToWorldNormal(v.normal);
				o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;

				o.uv=v.textcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;//使用纹理属性值maintexST来对顶点纹理坐标进行变换得到最终的纹理坐标。

				return o;
			}
			fixed4 frag(v2f i):SV_TARGET
			{
				fixed3 worldNormal=normalize(i.worldNormal);
				fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed3 albedo=tex2D(_MainTex,i.uv).rgb*_Color.rgb;//对纹理进行采样，第一个参数是被采样的纹理，第二个参数是float2类型的纹理坐标。
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;//使用采样结果和和颜色属性——Color的乘积来作为材质的反射率albedo.
				fixed3 diffuse=_LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));//漫反射的反射率使用了纹理采样得到的结果

				fixed3 viewDir=normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir=normalize(viewDir+worldLightDir);
				fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(worldNormal,halfDir)),_Gloss);

				return fixed4(ambient+diffuse+specular,1.0);
			}
			ENDCG	
		}
	}
	Fallback "Speacular"
}