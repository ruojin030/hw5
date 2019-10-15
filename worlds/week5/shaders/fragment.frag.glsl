#version 300 es        // NEWER VERSION OF GLSL
precision highp float; // HIGH PRECISION FLOATS

struct Material {
      vec3  ambient;
      vec3  diffuse;
      vec3  specular;
      float power;
      vec3  reflect;
      vec3  transparent;
      float indexOfRefraction;
};

uniform vec3  uColor;
uniform vec3  uCursor; // CURSOR: xy=pos, z=mouse up/down
uniform float uTime;   // TIME, IN SECONDS
uniform Material uMaterial;
const vec3 E = vec3(0.,0.,1.);

in vec2 vXY;           // POSITION ON IMAGE
in vec3 vPos;          // POSITION
in vec3 vNor;          // NORMAL

out vec4 fragColor;    // RESULT WILL GO HERE

void main() {
    /////////////////////////
    // TRY MOVE THE CURSOR //
    /////////////////////////


    vec3 color = vec3(0,0,0);
    vec3 lDir  = vec3(0,2,1);
    //vec3 lCol  = vec3(cos(uTime/2.)*sin(uTime-10.),sin(uTime),cos(uTime));
    vec3 lCol = vec3(0.6,0.2,0.2);
    vec3 diff  = uMaterial.diffuse * max(0., dot(lDir, normalize(vNor)));
    vec3 R     = 2.*dot(normalize(vNor),lDir)*normalize(vNor)-lDir;
    vec3 spec  = uMaterial.specular*pow(max(0.,dot(E,R)),uMaterial.power);
    vec3 shade = uMaterial.ambient + lCol*(diff+spec);
    color = shade;

    // HIGHLIGHT CURSOR POSITION WHILE MOUSE IS PRESSED

    if (uCursor.z > 0. && min(abs(uCursor.x - vXY.x), abs(uCursor.y - vXY.y)) < .01)
          color = vec3(1.,1.,1.);
    if(int(uTime*2.)%8 == 1){
        color = vec3(1.-sqrt(color.x),1.-sqrt(color.y),1.-sqrt(color.z));
    }
    fragColor = vec4(sqrt(color), 1.0);
}


