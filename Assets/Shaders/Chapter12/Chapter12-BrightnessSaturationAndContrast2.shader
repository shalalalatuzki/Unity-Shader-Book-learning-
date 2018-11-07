Shader "Unity Shaders Book/Chapter12/"
{
	Properties
	{
		_MainTex ("Base(RGB)", 2D) = "white" {}
		_Brightness("Brightness",Float)=1.0
		_Saturation("Saturation",Float)=1.0
		_Contrast("Contrast",Float)=1.0
	}
	SubShader
	{
		Pass
		{
			 ZTest always Cull Off ZWrite off

			 CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			float _Brightness;
			float _Saturation;
			float _Contrast;
			
			struct v2f{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
			};
			v2f vert(appdata_img v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv=v.texcoord;
				return o;
			}
			fixed4 frag(v2f i):SV_TARGET{
				fixed4 renderTex=tex2D(_MainTex,i.uv);
				fixed3 finalColor=renderTex.rgb*_Brightness;

				fixed Luminance=0.2125*renderTex.r+0.7154*renderTex.g+0.0721*renderTex.b;
				fixed3 LuminanceColor=fixed3(Luminance,Luminance,Luminance);
				finalColor=lerp(Luminance,finalColor,_Saturation);

				fixed3 avgColor=fixed3(0.5,0.5,0.5);
				finalColor=lerp(avgColor,finalColor,_Contrast);

				return fixed4(finalColor,renderTex.a);
			}
			 ENDCG

		}
	}
	Fallback Off
}