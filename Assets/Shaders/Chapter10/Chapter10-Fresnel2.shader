// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unity Shaders Book/Chapter10/fresnel"
{
	Properties
	{
		_Color("Color Tint",Color)=(1,1,1,1)
		_fresnelScale("Fresnel Scale",Range(0,1))=0.5
		_Cubemap("Reflection Cubemap",Cube)="_Skybox"{}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Geometry" }

		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma multi_compile_Fwdbase
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _Color;
			fixed _fresnelScale;
			samplerCUBE _Cubemap;
			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				fixed3 worldNormal:TEXCOORD0;
				fixed3 worldViewDir:TEXCOORD1;
				float3 worldPos:TEXCOORD2;
				fixed3 worldRefl:TEXCOORD3;
				SHADOW_COORDS(4)
			};

			v2f vert(a2v v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.worldNormal=UnityObjectToWorldNormal(v.normal);
				o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
				o.worldViewDir=UnityWorldSpaceViewDir(o.worldPos);
				o.worldRefl=reflect(-o.worldViewDir,o.worldNormal);
				TRANSFER_SHADOW(o);
				return o;
			}
			fixed4 frag(v2f i):SV_TARGET{
				fixed3 worldNormal=normalize(i.worldNormal);
				fixed3 worldViewDir=normalize(i.worldViewDir);
				fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 diffuse=_LightColor0.rgb*_Color.rgb*max(0,dot(worldViewDir,worldNormal));
				fixed3 reflection=texCUBE(_Cubemap,i.worldRefl);

				fixed3 fresnel=_fresnelScale+(1-_fresnelScale)*pow(1-dot(worldViewDir,worldNormal),5);
				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);
				fixed3 color=ambient+lerp(diffuse,reflection,saturate(fresnel))*atten;
				return fixed4(color,1.0);
			}
			ENDCG	
		}
	}
	Fallback "Reflection/VertexLit"
}