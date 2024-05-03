using UnityEngine;

public class BouncyBall : MonoBehaviour
{
    [SerializeField] Vector3 startForce;

    private Rigidbody rb;
    private void Start()
    {
        rb = GetComponent<Rigidbody>();
    }
    public void StartBallForce()
    {
        rb.useGravity = true;
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
                deformer.PushGroundUnder(hit.point, triangleIndex);
            }
        }

    }

}