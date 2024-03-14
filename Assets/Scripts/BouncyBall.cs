using UnityEngine;

public class BouncyBall : MonoBehaviour
{
    [SerializeField] Vector3 startForce;

    private void Start()
    {
        Rigidbody rb = GetComponent<Rigidbody>();
        rb.AddForce(startForce, ForceMode.Impulse);
    }

    private void OnCollisionEnter(Collision other)
    {
        if (other.collider.CompareTag("Ground"))
        {
            Debug.Log("Hit ground");
            SendRayDownwards();
        }
    }

    private void SendRayDownwards()
    {
        var dist = 5;
        var dir = new Vector3(0, -1, 0); //direction downwards 

        Debug.DrawRay(transform.position, dir * dist, Color.green);
        RaycastHit hit;
        if (Physics.Raycast(transform.position, dir, out hit, dist))
        {
            MeshDeformer deformer = hit.collider.GetComponent<MeshDeformer>();
            if (deformer)
            {
                //Vector3 point = hit.point;
                int triangleIndex = hit.triangleIndex;
                deformer.PushGroundUnder(triangleIndex);
            }
        }

    }

}