using System;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
public class MeshDeformer : MonoBehaviour
{
    Mesh deformingMesh;
    Vector3[] originalVertices, displacedVertices;

    Vector3[] vertexVelocities;

    //public float springForce = 20f;

    public float damping = 5f;

    float uniformScale = 1f;
    private void Start()
    {
        deformingMesh = GetComponent<MeshFilter>().mesh;
        originalVertices = deformingMesh.vertices;
        displacedVertices = new Vector3[originalVertices.Length];
        for (int i = 0; i < originalVertices.Length; i++) //displaced vertices get the original vertices first
        {
            displacedVertices[i] = originalVertices[i];
        }

        vertexVelocities = new Vector3[originalVertices.Length];
    }
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
    void Update()
    {
        uniformScale = transform.localScale.x;
        for (int i = 0; i < displacedVertices.Length; i++)
        {
            UpdateVertex(i);
        }
        deformingMesh.vertices = displacedVertices;
        deformingMesh.RecalculateNormals();
    }

    void UpdateVertex(int i)
    {
        Vector3 velocity = vertexVelocities[i];
        Vector3 displacement = displacedVertices[i] - originalVertices[i];
        displacement *= uniformScale;
        //velocity -= displacement * springForce * Time.deltaTime;
        velocity *= 1f - damping * Time.deltaTime;
        vertexVelocities[i] = velocity;
        displacedVertices[i] += velocity * (Time.deltaTime / uniformScale);
    }

}
