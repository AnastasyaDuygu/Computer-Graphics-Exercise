
# Computer Graphics Exercise

This project is made up of 4 scenes: a sample scene, **bouncy ball mini game** scene, **CatLikeCoding Rendering** scene and lastly **FreyaHolmer CG**  scene.
  

#### The **credits** for this project goes to:
- [CatLikeCoding](https://catlikecoding.com/unity/tutorials/rendering/) website for Rendering.
- Freya Holmer's [Shaders For Game Devs](https://www.youtube.com/watch?v=kfM-yu0iQBk&list=PLImQaTpSAdsCnJon-Eir92SZMl7tPBS4Z) playlist on YouTube.

# Purpose*
   

My **main goal** was to learn and start **GPU programming** and know what a computer is capable of doing with shaders, so that i know when to use GPU programming and when to stick to CPU programming.  

This exercise is made up of **THREE** sections. 

## 1. Bouncy Ball Mini Game

//photos
## How to Play?

- Tap the starting screen to get started.
- You can tap anywhere on the ground to pave the ground down.
- The game does not end until you hit the replay or the quit button.
- Happy paving!
### Downloading Release and Playing

You can easily download and play the mini-game by following these steps:

&nbsp;&nbsp;&nbsp; 1. Go to the [Releases](https://github.com/AnastasyaDuygu/Computer-Graphics-Exercise/releases) section of this repository.  
&nbsp;&nbsp;&nbsp; 2. Find the latest release and click on it.  
&nbsp;&nbsp;&nbsp; 3. Download the ` BouncyBallMiniGame.zip ` file from the release.  
&nbsp;&nbsp;&nbsp; 4. Unzip the zip file.    
&nbsp;&nbsp;&nbsp; 5. Run ` Bouncy Ball & Mesh Deformer Mini Game` application file to start playing the game !

## Installation


To run the CG Exercises repository on your Windows system, follow these steps:

&nbsp;&nbsp;&nbsp; 1. Clone this repository or download it as a ZIP file.  
&nbsp;&nbsp;&nbsp; 2. Open the project in Visual Studio or your preferred C++ IDE.  
&nbsp;&nbsp;&nbsp; 3. Build and run the project.    


## 2. CatLikeCoding Rendering

In this section I learn the **basics of rendering** a mesh on to an object and how a **shader** works.    


### My First Shader

&nbsp;&nbsp;&nbsp;I wrote my first shader code which I named as "**MyFirstShader**" unironically. This and every other shader I have written for this exercise is an **Unlit Shader** to avoid overcomplicating things from the start.    
 
&nbsp;&nbsp;&nbsp;**MyFirstShader**'s function is to get a texture and a tint and **paste the texture** on to an object **with the given tint**.    

//sphere photo

### Combining Textures

&nbsp;&nbsp;&nbsp;After conquering my first goal, which was to write a simple shader code I moved on to bigger and better things: **combining textures**.  

&nbsp;&nbsp;&nbsp;For this I created the "**Textured With Detail**" shader which gets two textures and a tint and combines these two textures with the tint given to project onto the mesh.

//combining textures photo
 
 
## 3. Freya Holmer Computer Graphics

At this point I have familiarized myself with vertex and fragment shaders and their functions.

### &nbsp; PART 1

### Basic Mango Shader

&nbsp;&nbsp;&nbsp;The "**mango**" shader is the shader that uses the **objects' normals** to project a color onto a surface. The reason it is sometimes referred to as mango is because the color scheme looks similar to that of a mango.  

&nbsp;&nbsp;&nbsp;In the vertex shader of this shader I wrote:  
`o.normal = normalize(mul ((float3x3)UNITY_MATRIX_M, v.normals));` to make the normals stay the same when the object is rotated or moved in the scene. Basically this piece of code **prevents static normals**.

//mango photo
 
### UV Gradient Shader

&nbsp;&nbsp;&nbsp;This shader includes **quad uv mapping** and **dynamic triangle waves**. In this shader I got to experiment a lot with the fragment shader who is in charge of rendering colors for each pixel.

&nbsp;&nbsp;&nbsp;To over simplify what this shader does; It **creates a gradient** between two colors by **using the UV map** of the object, and with a mathematical wave equation and `_Time` property creates **moving triangle waves**.

//uv gradient photo

### Additive/Multiply Shader

&nbsp;&nbsp;&nbsp;In this shader I experimented with **transparent** render type and depth buffer, additive/multiply blend commands to get the desired outcome.  

&nbsp;&nbsp;&nbsp;In the end I re-used the **UV Gradient** shaders' gradient blend and moving triangle waves on a cylinder and made one of the blend colors transparent to have a "**teleport point**" effect.

//additive multiply photo

### Vertex Offset Shader

&nbsp;&nbsp;&nbsp;With this shader I modified the position of vertices in a mesh using vertex fragment function. 

&nbsp;&nbsp;&nbsp;By using a tessellated plane and the **vertex shader** I created two different effects on the tessellated plane meshes: **wave and ripple**.

// vertex offset photo

### Texture with Pattern Shader

&nbsp;&nbsp;&nbsp;This shader uses a main texture, detail texture and a pattern texture to create mixture of patterned textures.

//texture pattern photo

### &nbsp; PART 2
### Healthbar Shader

&nbsp;&nbsp;&nbsp;There are three shader codes for this section and they are: **HealthBar**, **RoundedBar** & **RoundedHealthBar** all of them unique in their seperate ways.  

&nbsp;&nbsp;&nbsp;The **HealthBar** uses a **texture** to determine the **color** of the bar (*there is also a code that does the same thing without the texture but it's commented out*) according to how much health a player has and also it starts **flashes** when player health is lower than 20/100.

//healthbar 1,2,3,4 photos

&nbsp;&nbsp;&nbsp;The **RoundedBar** is basically the black and white version of a health bar with **rounded corners**.

//healthbar 5 photo

&nbsp;&nbsp;&nbsp;The **RoundedHealthBar** is the **combination** of HealthBar and RoundedBar.  

//healthbar 6,7 photos

### Lighting Shaders

&nbsp;&nbsp;&nbsp;I wrote two shaders for lighting: **LightingShader** and **FernelShader**.  

&nbsp;&nbsp;&nbsp;In this segment I experimented with:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. **Lambertian shading** (diffuse lighting),  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. **Phong shading** (specular lighting),  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. **Blinn Phong shading** (specular lighting). 

//lighting shader, 2 photos

### &nbsp; PART 3

### Multiple Light Shader

&nbsp;&nbsp;&nbsp;In this shader I used a cginc file for the first time to avoid repetive coding segments because it had multiple passes since multiple lights means more than one pass when rendering. 

&nbsp;&nbsp;&nbsp;This is basically the same shader as **LightingShader** but made **compatible with multiple light** sources.

//multi 1,2 photos

### Color/Albedo Shader

&nbsp;&nbsp;&nbsp;This shader creates a **3D affect** using a normal map and an albedo texture map even though **it's completely flat**. Meaning it only uses the fragment shader to create that effect with lighting.

//color albedo 1,2 photos

### Height Map Shader

&nbsp;&nbsp;&nbsp;In this shader on top of using a **normal map** and an **albedo texture** map, I make use of a **height map** and convert the previously flat surface to a 3D surface using the vertex shader.

//height map photo

### Ambient Light Shader

&nbsp;&nbsp;&nbsp;Ambient lighting is used to avoid black shadows that gives the image a cheap feel. This shader is compatible with multiple light sources and has an `_AmbientLight` parameter that adds ambient light at the end of fragment shader lighting calculations.

//ambient light photo

### Diffuse IBL* Shader

&nbsp;&nbsp;&nbsp;This shader uses a "**diffuse *IBL****" image to create the illusion of the environment reflecting off the surface of the object. 

// diffuse ibl photo

### Specular IBL* Shader

&nbsp;&nbsp;&nbsp;This shader uses a "**specular "*IBL****", which is clearer than the "diffuse *IBL**" image, in order to create the illusion of the environment reflecting off the objetcs' surface. 

//specular ibl photo

IBL* : *image based lighting*