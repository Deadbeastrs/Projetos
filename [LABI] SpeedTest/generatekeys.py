from Crypto.PublicKey import RSA
from Crypto.Cipher import AES
from Crypto.Cipher import PKCS1_OAEP
import os

def generate_key():
    privk = RSA.generate(2048)
    pubk = privk.publickey()

    privkf = open('key.priv.pem', 'wb')
    privkf.write(privk.exportKey('PEM'))

    pubkf = open('key.pub.pem', 'wb')
    pubkf.write(pubk.exportKey('PEM'))

    privkf.close()
    pubkf.close()
generate_key()