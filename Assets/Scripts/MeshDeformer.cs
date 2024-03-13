using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

[RequireComponent(typeof(MeshFilter))]
public class MeshDeformer : MonoBehaviour
{
    Mesh deformingMesh;
    Vector3[] originalVertices, displacedVertices;

    public delegate void OnMeshChanged();
    public OnMeshChanged onMeshChangedCallback;
    private void Start()
    {
        
        deformingMesh = GetComponent<MeshFilter>().mesh;
        originalVertices = deformingMesh.vertices;
        displacedVertices = new Vector3[originalVertices.Length];
        for (int i = 0; i < originalVertices.Length; i++) //displaced vertices get the original vertices first
        {
            displacedVertices[i] = originalVertices[i];
        }
    }
    void Update()
    {
        deformingMesh.vertices = displacedVertices;
        deformingMesh.RecalculateNormals();
    }

    public void PushGroundUnder(Vector3 point, int triangleIndex)
    {
        Debug.DrawLine(Camera.main.transform.position, point);
        point = transform.InverseTransformPoint(point); //for the point of impact to not be affected by change in tranformation***

        var t = checkTriangleIdex(triangleIndex); //Check index first
        Debug.Log("TRIANGLE INDEX: " + t);
        var n = calculateN(t); //Calculate n
        Debug.Log("N: " + n);
        var squaresPerRow = FindAnyObjectByType<MeshGenerator>().GetSquaresPerRow();
        Debug.Log("SQUARES PER ROW: " + squaresPerRow);
        var rowNumber = calculateRowNumber(n, squaresPerRow); //calculate row number
        Debug.Log("ROW NUMBER: " + rowNumber);
        var startIndex = computeStartIndex(t, n, rowNumber, squaresPerRow); //find start index
        Debug.Log("START INDEX: " + startIndex);
        Vector3[] modifiedVertices = calculateModifiedVertices(startIndex); //list of modified indexes
        Debug.Log("MODIFIED VERTICES: " + modifiedVertices[0] + " " + modifiedVertices[1] + " " + modifiedVertices[2] + " " + modifiedVertices[3]);
        foreach (var i in modifiedVertices)
        {
            pushDownVertex(i);
        }
    }

    private int checkTriangleIdex(int triangleIndex)
    {
        if (triangleIndex % 2 == 0) return triangleIndex - 1; else return triangleIndex;
    }

    private int calculateN(int t)
    {
        return (t + 1) / 2;
    }

    private int calculateRowNumber(int n, int squaresPerRow)
    {
        return Mathf.FloorToInt((n - 1) / squaresPerRow);
    }

    private Vector3 computeStartIndex(int t, int n, int rowNum, int squaresPerRow)
    {
        return new Vector3(t - n - (rowNum * squaresPerRow), 0, rowNum);
    }

    private Vector3[] calculateModifiedVertices(Vector3 startIndex)
    {
        int[] indexModX = { 0, 1, 1 };
        int[] indexModZ = { 1, 0, 1 };

        Vector3[] modifiedVertices = new Vector3[indexModX.Length + 1];
        modifiedVertices[0] = startIndex;

        for (int i = 0; i < indexModX.Length; i++)
        {
            var xafter = startIndex.x + indexModX[i];
            var zafter = startIndex.z + indexModZ[i];

            modifiedVertices[i + 1] = new Vector3(xafter, 0, zafter);
            //Debug.Log("MODIFIED VERTICE: " + modifiedVertices[i + 1]);
        }

        return modifiedVertices;
    }

    private void pushDownVertex(Vector3 modifiedVertex)
    {
        List<int> listOfIndexes = findAllIndexesOfItem(displacedVertices, modifiedVertex);
        foreach(int index in listOfIndexes)
        {
            DOTween.To(() => displacedVertices[index], x => displacedVertices[index] = x, new Vector3(displacedVertices[index].x, displacedVertices[index].y - 5, displacedVertices[index].z), 1);
            //Debug.Log("DISPLACED VERTICES: " + displacedVertices[index]);
        }
        if (onMeshChangedCallback != null)
            onMeshChangedCallback.Invoke();
    }

    private List<int> findAllIndexesOfItem(Vector3[] vertices, Vector3 item)
    {
        List<int> indexList = new List<int>();
        for(int i = 0; i< vertices.Length; i++)
        {
            if (vertices[i] == item)
            {
                indexList.Add(i);
            }
        }
        return indexList;
    }




    //---------------------------------------------------------------------------------------------------------------------------//
    //Vector3[] vertexVelocities;

    //public float springForce = 20f;

    //public float damping = 5f;

    //float uniformScale = 1f;
    /*
     update -> //uniformScale = transform.localScale.x;
        for (int i = 0; i < displacedVertices.Length; i++)
        {
            UpdateVertex(i);
        }
    start -> //vertexVelocities = new Vector3[originalVertices.Length];
    public void TakeOutPieceOfMesh(Vector3 point, int triangleIndex)
    {
        Debug.DrawLine(Camera.main.transform.position, point);
        point = transform.InverseTransformPoint(point); //for the point of impact to not be affected by change in tranformation***
        if (triangleIndex > displacedVertices.Length || triangleIndex < 0) return;
        for(int i = triangleIndex-1; i <triangleIndex; i++)
        {
            TakeOutPieceFromVertex(i, point);
        }
                                           //Debug.Log(displacedVertices.Length);
        
    }

    private void TakeOutPieceFromVertex(int i, Vector3 point)
    {
        Vector3 pointToVertex = displacedVertices[i] - point;
        pointToVertex.y -= 100;
        vertexVelocities[i] += pointToVertex.normalized;
    }

    public void AddDeformingForce(Vector3 point, float force) //NOT USED
    {
        Debug.DrawLine(Camera.main.transform.position, point); //for debug purposes

        point = transform.InverseTransformPoint(point); //for the point of impact to not be affected by change in tranformation
        for (int i = 0; i < displacedVertices.Length; i++)
        {
            
            AddForceToVertex(i, point, force);
        }
        
    }

    void AddForceToVertex(int i, Vector3 point, float force)
    {
        Vector3 pointToVertex = displacedVertices[i] - point;
        pointToVertex *= uniformScale;
        float attenuatedForce = force / (1f + pointToVertex.sqrMagnitude);
        float velocity = attenuatedForce * Time.deltaTime;
        vertexVelocities[i] += pointToVertex.normalized * velocity;
    }

    void UpdateVertex(int i)
    {
        Vector3 velocity = vertexVelocities[i];
        Vector3 displacement = displacedVertices[i] - originalVertices[i];
        //displacement *= uniformScale;
        //velocity -= displacement * springForce * Time.deltaTime;
        velocity *= 1f - damping * Time.deltaTime;
        vertexVelocities[i] = velocity;
        displacedVertices[i] += velocity * (Time.deltaTime / uniformScale);
    }*/

}
