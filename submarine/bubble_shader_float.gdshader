shader_type canvas_item;

uniform float timeScale = 2;
uniform float amplitude = 10.0f;

void vertex() {
	VERTEX.y += sin(TIME * timeScale + VERTEX.y + VERTEX.x) * amplitude;
}

void fragment() {
}