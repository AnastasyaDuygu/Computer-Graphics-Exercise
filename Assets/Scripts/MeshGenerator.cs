using UnityEngine;
using UnityEngine.Rendering;

public class MeshGenerator : MonoBehaviour
{
    MeshFilter _meshFilter;
    Renderer _renderer;

    private void Awake()
    {
        _renderer = GetComponent<Renderer>();
        _meshFilter = GetComponent<MeshFilter>();
        
        if (name == "Cube")
            _meshFilter.mesh = GenerateCubeMesh();
        else if (name == "Pyramid")
            _meshFilter.mesh = GeneratePyramidMesh();
    }

    private Mesh GenerateCubeMesh()
    {

        Mesh mesh = new Mesh();

        mesh.subMeshCount = 2;
        Debug.Log(_renderer.materials.GetValue(0)); //works correctly
        Debug.Log(_renderer.materials.GetValue(1));

        Vector2[] uvs = new Vector2[36];
        var vertices = new Vector3[36]
        {
            //front
            Vector3.zero,
            new Vector3(0, 1, 0),
            new Vector3(1, 0, 0),

            new Vector3(1 ,0 ,0),
            new Vector3(0, 1, 0),
            new Vector3(1, 1, 0),
            //right side
            new Vector3(1, 0, 0),
            new Vector3(1, 1, 0),
            new Vector3(1 ,0 ,1),

            new Vector3(1, 1, 0),
            new Vector3(1, 1, 1),
            new Vector3(1 ,0 ,1),
            //left side
            Vector3.zero,
            new Vector3(0, 0, 1),
            new Vector3(0 ,1 ,0),

            new Vector3(0, 0, 1),
            new Vector3(0, 1, 1),
            new Vector3(0 ,1 ,0),
            //back side
            new Vector3(1, 0, 1),
            new Vector3(0, 1, 1),
            new Vector3(0, 0, 1),

            new Vector3(1 ,0 ,1),
            new Vector3(1, 1, 1),
            new Vector3(0, 1, 1),
            //top
            new Vector3(1, 1, 0),
            new Vector3(0, 1, 0),
            new Vector3(1, 1, 1),

            new Vector3(1 ,1 ,1),
            new Vector3(0, 1, 0),
            new Vector3(0, 1, 1),
            //bottom
            new Vector3(1, 0, 1),
            new Vector3(0, 0, 0),
            new Vector3(1, 0, 0),

            new Vector3(0, 0, 1),
            new Vector3(0, 0, 0),
            new Vector3(1 ,0 ,1),
        };
        mesh.vertices = vertices;

        //uv doesn't do anything :<
        for (int i = 0; i < 36; i += 4)
        {
            uvs[i] = new Vector2(0, 0);
            uvs[i + 1] = new Vector2(1, 0);
            uvs[i + 2] = new Vector2(1, 1);
            uvs[i + 3] = new Vector2(0, 1);
        }
        mesh.uv = uvs;
        //

        var triangles1 = new int[18];
        for (int i = 0; i < triangles1.Length; i++)
        {
            triangles1[i] = i;
        }
        var triangles2 = new int[18];
        for (int i = 0; i < triangles2.Length; i++)
        {
            triangles2[i] = i+triangles1.Length;
        }
        mesh.SetTriangles(triangles1, 0);
        mesh.SetTriangles(triangles2, 1);
        return mesh;
    }

    private Mesh GeneratePyramidMesh()
    {

        Mesh mesh = new Mesh();
        var vertices = new Vector3[18]
        {
            //bottom
            new Vector3(1, 0, 1),
            new Vector3(0, 0, 0),
            new Vector3(1, 0, 0),

            new Vector3(0, 0, 1),
            new Vector3(0, 0, 0),
            new Vector3(1 ,0 ,1),
            //front
            new Vector3(0, 0, 0),
            new Vector3(0.5f, 1, 0.5f),
            new Vector3(1, 0, 0),
            //back
            new Vector3(1, 0, 1),
            new Vector3(0.5f, 1, 0.5f),
            new Vector3(0, 0, 1),
            //right
            new Vector3(1, 0, 0),
            new Vector3(0.5f, 1, 0.5f),
            new Vector3(1, 0, 1),
            //left
            new Vector3(0, 0, 1),
            new Vector3(0.5f, 1, 0.5f),
            new Vector3(0, 0, 0),


        };
        mesh.vertices = vertices;
        var triangles = new int[18];
        for (int i = 0; i < triangles.Length; i++)
        {
            triangles[i] = i;
        }
        mesh.triangles = triangles;
        
        return mesh;
    }
}

/*private Vector3[] generateCubeVertices(Vector3 startPos) // get starting position and generates sides
    {
        int index = 0;
        var x = (int)startPos.x;
        var y = (int)startPos.y;
        var z = (int)startPos.z;
        var vertices = new Vector3[36];
        //FRONT & BACK
        int[] X = new int[6] { 0, 0, 1, 1, 0, 1};
        int[] Y = new int[6] { 0, 1, 0, 0, 1, 1};
        int[] Z = new int[6] { 0, 0, 0, 0, 0, 0};
        for (int i = 0; i < 6; i++) //front side
        {
            int xafter = x;
            int yafter = y;
            int zafter = z;

            xafter += X[i];
            yafter += Y[i];
            zafter += Z[i];

            //add to vertices array
            var vertice = new Vector3(xafter, yafter, zafter); 
            vertices[index] = vertice;
            index++;
        }
        for (int i = 5; i >= 0; i--) //back side
        {
            int xafter = x;
            int yafter = y;
            int zafter = z+1;

            xafter += X[i];
            yafter += Y[i];
            zafter += Z[i];

            //add to vertices array
            var vertice = new Vector3(xafter, yafter, zafter); 
            vertices[index] = vertice;
            index++;
        }
        return vertices;
    }*/