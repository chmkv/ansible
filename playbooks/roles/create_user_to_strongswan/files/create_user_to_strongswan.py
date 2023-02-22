import sys, os, hashlib

def content() -> str:
    with open("/etc/strongswan/ipsec.secrets", "r") as file:
        ipsecsecrets = file.read()
    return ipsecsecrets

def check(name) -> bool:
    if name in content():
        return True
    else:
        return False

def add(name) -> str:
    password = hashlib.md5(os.urandom(256)).hexdigest()
    base = content()
    with open("/etc/strongswan/ipsec.secrets", "w") as file:
        file.write(f'{base}\n{name} : EAP "{ password }"\n')
    return password

def config(name, password) -> str:
    with open("/opt/python/config/ios.mobileconfig", "r") as file:
        ios = file.read()
    with open("/etc/strongswan/ipsec.d/cacerts/content.ca-cert", "r") as file:
        cert = file.read()
    ios = ios.replace("CERTIFICATE_CONTENT", cert)
    ios = ios.replace("LOGIN_CONTENT", name)
    ios = ios.replace("PASSWORD_CONTENT", password)
    with open(f"/opt/python/config/{name}.mobileconfig", "w") as file:
        file.write(ios)

def ipsec(name) -> str:
    if check(name):
        return f"Sorry, user: {name} already exists\nPlease choose a different username"
    password = add(name)
    config(name, password)
    os.system("systemctl restart strongswan")
    return f"User: {name}\nPassword: {password}\nSuccessfully added!"

def main():
    print(ipsec(sys.argv[1]))

if __name__ == "__main__":
    main()