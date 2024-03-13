using System;
using UnityEngine;

public class MeshGenerator : MonoBehaviour
{
    MeshFilter _meshFilter;
    Renderer _renderer;
    MeshCollider _meshCollider;

    const int squaresPerRow = 12;
    const int numOfVertices = squaresPerRow * squaresPerRow * 6;
    int numOfSquares = (int)Math.Sqrt(numOfVertices / 6);

    private void Awake()
    {
        _renderer = GetComponent<Renderer>();
        _meshFilter = GetComponent<MeshFilter>();
        _meshCollider = GetComponent<MeshCollider>();

        if (name == "Cube")
            _meshFilter.mesh = GenerateCubeMesh();
        else if (name == "Pyramid")
            _meshFilter.mesh = GeneratePyramidMesh();
        else if (name == "Plane Mesh")
        {
            _meshFilter.mesh = GeneratePlaneMesh();
            _meshCollider.sharedMesh = _meshFilter.mesh;
        }
    }

    private Mesh GeneratePlaneMesh()
    {
        Mesh mesh = new Mesh();
        var vertices = new Vector3[numOfSquares*numOfSquares, 6];
        var finalVertices = new Vector3[numOfVertices];
        int a = 0;
        for (int z = 0; z < numOfSquares; z++) //column
        {
            for (int x = 0; x < numOfSquares; x++) //row
            {
                var vector3s = createTriangleVertices(new Vector3((float)x, 0, (float)z));
                /*Debug.Log(vector3s[0] + " " + vector3s[1] + " " + vector3s[2]);
                Debug.Log(vector3s[3] + " " + vector3s[4] + " " + vector3s[5]);*/
                vertices[a, 0] = vector3s[0];
                vertices[a, 1] = vector3s[1];
                vertices[a, 2] = vector3s[2];
                vertices[a, 3] = vector3s[3];
                vertices[a, 4] = vector3s[4];
                vertices[a, 5] = vector3s[5];
                a++;
            }    
        }
        //Debug.Log(a); // 81
        finalVertices = convertMatrixToArray(vertices); //not working
        mesh.vertices = finalVertices;

        var triangles = new int[numOfVertices];
        for (int i = 0; i < triangles.Length; i++)
        {
            triangles[i] = i;
        }
        mesh.triangles = triangles;
        return mesh;
    }
    private Vector3[] createTriangleVertices(Vector3 startIndex)
    {
        int[] indexModX = { 0, 1};
        int[] indexModZ = { 1, 1};

        int[] indexModX2 = { 1, 1 };
        int[] indexModZ2 = { 1, 0 };

        Vector3[] vertices = new Vector3[6];
        vertices[0] = startIndex;
        vertices[3] = startIndex;
        for (int i = 0;i < indexModX.Length; i++)
        {
            var xafter = startIndex.x + indexModX[i];
            var zafter = startIndex.z + indexModZ[i];
            vertices[i + 1] = new Vector3(xafter, 0, zafter);
            xafter = startIndex.x + indexModX2[i];
            zafter = startIndex.z + indexModZ2[i];
            vertices[i + 4] = new Vector3(xafter, 0, zafter);
        }
        return vertices;
    }
    private Vector3[] convertMatrixToArray(Vector3[,] matrixArray)
    {
        Vector3[] vertices = new Vector3[numOfVertices];
        int x = 0;
        for (int z = 0; z < numOfSquares * numOfSquares; z++) //column
        {
            for (int i = 0; i < 6; i++) //row
            {
                vertices[x] = matrixArray[z, i];
                x++;
            }
        }
        return vertices;
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

    public int GetSquaresPerRow()
    {
        return squaresPerRow;
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