precision highp float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    // Directly set the output color to black
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
