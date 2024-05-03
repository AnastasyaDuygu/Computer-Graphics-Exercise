using UnityEngine;
using UnityEngine.EventSystems;

public class MeshDeformerInput : MonoBehaviour
{
    
    //public float force = 10f;
    
    public float forceOffset = 0.1f; //guarantees vertices will be pushed inward and NOT outwards

    void Update()
    {
        if (Input.GetMouseButton(0))
        {
            if (!EventSystem.current.IsPointerOverGameObject())
            {
                HandleInput();
            }
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
                int triangleIndex = hit.triangleIndex; //TODO: FIX THIS
                //point += hit.normal * forceOffset;
                deformer.PushGroundUnder(point, triangleIndex);
            }
        }
    }
}