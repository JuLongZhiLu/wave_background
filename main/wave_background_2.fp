// 定义常量块 (注意：名字要和材质编辑器里的 Name 一致)
uniform mediump vec4 time_data; 

varying mediump vec2 var_texcoord0;

void main()
{
	// 获取引擎自动传入的时间
	// time_data.x 是引擎启动后的总秒数
	float t = time_data.x;

	// 1. 调整坐标缩放和倾斜度
	// 将 UV 坐标旋转或相加，可以产生斜向的效果
	// 我们让 X 和 Y 加上时间，产生向右下角移动的效果
	mediump vec2 uv = var_texcoord0 * 8.0; 

	float speed = t * 2.0;

	// 2. 核心波浪算法
	// 通过 sin(x + y - t) 实现对角线流动的波浪
	float wave = sin(uv.x + uv.y - speed);

	// 3. 定义颜色
	lowp vec3 color_bright = vec3(0.0, 0.6, 1.0); // 浅蓝
	lowp vec3 color_dark = vec3(0.0, 0.45, 0.9);  // 深蓝

	// 4. 硬边缘切割 (根据 sin 值的正负来决定颜色)
	lowp float mask = step(0.0, wave);
	lowp vec3 final_color = mix(color_dark, color_bright, mask);

	gl_FragColor = vec4(final_color, 1.0);
}