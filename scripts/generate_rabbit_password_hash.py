#!/usr/bin/env python
import sys
import random
import hashlib
import base64


def rabbitmqhash(pwd):
    plaintext_pwd = sys.argv[1]
    salt = random.getrandbits(32).to_bytes(4, "little")
    pwd_utf8 = plaintext_pwd.encode()
    temp1 = hashlib.sha256(salt + pwd_utf8).digest()
    return base64.b64encode(salt + temp1).decode()


if __name__ == "__main__":
    for pwd in sys.argv[1:]:
        print(f"{pwd} -> {rabbitmqhash(pwd)}")
