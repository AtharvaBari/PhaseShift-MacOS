import base64
import ed25519

public_key_base64 = "x3892CZBKrTWaMWswBvwoD5X+gdVhgPbVq5W0drZt4s="
signature_base64 = "0DRU6lTUHhxeaFPMQCPCrScMinJAPauMkkV1E+HMkhL7QeA5TNtwQUjBJLmelpVZv/N1t05zezItdQpubOB/Dw=="

with open("PhaseShift_v2.0.5.zip", "rb") as f:
    data = f.read()

public_key_bytes = base64.b64decode(public_key_base64)
signature_bytes = base64.b64decode(signature_base64)

vk = ed25519.VerifyingKey(public_key_bytes)
try:
    vk.verify(signature_bytes, data)
    print("VERIFIED SUCCESS")
except Exception as e:
    print(f"VERIFIED FAILURE: {e}")
