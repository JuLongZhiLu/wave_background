uniform mediump vec4 time_data; 
varying mediump vec2 var_texcoord0;

void main()
{
	float t = time_data.x;

	// 1. 调整缩放：x 轴缩放小一点（让色块宽一些），y 轴放大切碎一些
	// 如果想要波浪更少/更宽，减小 3.0；如果想要上下起伏更密，增加 4.0
	mediump vec2 uv = var_texcoord0 * vec2(6.0, 8.0); 

	// 2. 移动速度
	float speed = t * 1.5;

	// 3. 核心算法：制造这种“圆滑锯齿”
	// 我们在 X 轴的分布上，混入一个随 Y 轴摆动的偏移
	// sin(uv.y + speed) 制造了随高度变化的左右摆动
	// + uv.x 决定了基本的垂直分列
	// - speed 让整体向右下方流动
	float wave_shape = sin(uv.x + sin(uv.y + speed) * 1.2 - speed);

	// 4. 定义紫色调（参考原图）
	lowp vec3 color_light = vec3(0.7, 0.2, 1.0); // 浅紫
	lowp vec3 color_dark = vec3(0.5, 0.1, 0.9);  // 深紫

	// 5. 产生硬边锯齿效果
	lowp float mask = step(0.0, wave_shape);
	lowp vec3 final_color = mix(color_dark, color_light, mask);

	gl_FragColor = vec4(final_color, 1.0);
}