Shader "Unity Shaders Book/Chapter 7 /Ramp Texture"
{
	Properties
	{
		_Color("Color Tint",Color)=(1,1,1,1)
		_RampTex("Ramp Tex",2D)="white"{}
		_Specular("Specular",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8.0,256))=20
		
	}
	SubShader
	{
		Pass
		{
			Tags{"LightMode"="Forwarbase"}
			CGPROGRAM
			
			ENDCG
		}
	}
}