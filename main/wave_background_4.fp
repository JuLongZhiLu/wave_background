uniform mediump vec4 time_data; 
varying mediump vec2 var_texcoord0;

void main()
{
	float t = time_data.x;
	float speed = t * 2.0;

	// 1. 缩放坐标
	mediump vec2 uv = var_texcoord0 * 8.0; 

	// 2. 实现“圆滑锯齿”的关键：
	// 我们在原来的坐标基础上，增加一个随着 Y 坐标变化的偏移量
	// sin(uv.y * 1.5 + speed * 0.5) 创建了一个上下摆动的偏移
	// 0.8 是锯齿的“深度”（越大锯齿越明显）
	float wobble = sin(uv.y * 1.5 + speed * 0.5) * 0.8;

	// 3. 将这个 wobble 应用到 X 轴
	// 这样原来的直线（uv.x + uv.y）就会被扭曲成锯齿状
	float wave = sin((uv.x + uv.y) - speed + wobble);

	// 4. 颜色处理
	lowp vec3 color_bright = vec3(0.0, 0.6, 1.0); 
	lowp vec3 color_dark = vec3(0.0, 0.45, 0.9);  
	lowp float mask = step(0.0, wave);

	gl_FragColor = vec4(mix(color_dark, color_bright, mask), 1.0);
}