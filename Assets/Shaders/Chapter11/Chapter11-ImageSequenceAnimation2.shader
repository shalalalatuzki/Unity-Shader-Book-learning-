Shader "Unity Shaders Book/Chapter11/SceneImage"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Color Tint",Color)=(1,1,1,1)
		_HorizontalAmount("Horizonta Amount",Float)=4
		_VerticalAmount("Vertical Amount",Float)=4
		_Speed("Speed",Range(1,100))=30
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

		Pass
		{
			Tags { "LightMode"="ForwardBase"}
			ZWrite Off
			Blend ScrAlpha oneMinusSrcAlpha

			cg
		}
	}
}