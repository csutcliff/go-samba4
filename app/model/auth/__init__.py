import os
import sys

lib_samba = ['/opt/samba4/lib/python3.6/site-packages',
             '/opt/samba4/lib64/python3.6/site-packages',
             '/opt/samba4/lib/python3.7/site-packages',
             '/opt/samba4/lib64/python3.7/site-packages',
             '/opt/samba4/lib/python3.8/site-packages',
             '/opt/samba4/lib64/python3.8/site-packages',
             '/opt/samba4/lib/python3.9/site-packages',
             '/opt/samba4/lib64/python3.9/site-packages',
             '/usr/local/samba/lib/python3.6/site-packages',
             '/usr/local/samba/lib64/python3.6/site-packages',
             '/usr/local/samba/lib/python3.7/site-packages',
             '/usr/local/samba/lib64/python3.7/site-packages',
             '/usr/local/samba/lib/python3.8/site-packages',
             '/usr/local/samba/lib64/python3.8/site-packages',
             '/usr/local/samba/lib/python3.9/site-packages',
             '/usr/local/samba/lib64/python3.9/site-packages'
             ]

for i in lib_samba:
    if os.path.exists(i):
        sys.path.append(i)
