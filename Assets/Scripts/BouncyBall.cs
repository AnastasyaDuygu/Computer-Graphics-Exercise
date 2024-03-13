using UnityEngine;

public class BouncyBall : MonoBehaviour
{
    /*public float forceOffset = 0.1f;

    
    void Update()
    {
        if (Input.GetMouseButton(0))
        {
            HandleInput();
        }
    }
    void HandleInput()
    {
        Ray inputRay = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(inputRay, out hit))
        {
            MeshDeformer deformer = hit.collider.GetComponent<MeshDeformer>();
            if (deformer)
            {
                Vector3 point = hit.point;
                int triangleIndex = hit.triangleIndex;
                point += hit.normal * forceOffset;
                deformer.TakeOutPieceOfMesh(point, triangleIndex);
            }
        }
    }*/
}
