import os
import json
import base64
import getpass
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend
from cryptography.fernet import Fernet

DATA_FILE = "vault.enc"
SALT_FILE = "salt.bin"

def generate_salt():
    return os.urandom(16)

def save_salt(salt):
    with open(SALT_FILE, "wb") as f:
        f.write(salt)

def load_salt():
    if not os.path.exists(SALT_FILE):
        salt = generate_salt()
        save_salt(salt)
        return salt
    with open(SALT_FILE, "rb") as f:
        return f.read()

def derive_key(password: str, salt: bytes) -> bytes:
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=100_000,
        backend=default_backend()
    )
    return base64.urlsafe_b64encode(kdf.derive(password.encode()))

def save_data(data, key):
    f = Fernet(key)
    encrypted = f.encrypt(json.dumps(data).encode())
    with open(DATA_FILE, "wb") as f_out:
        f_out.write(encrypted)

def load_data(key):
    if not os.path.exists(DATA_FILE):
        return {"accounts": []}
    f = Fernet(key)
    with open(DATA_FILE, "rb") as f_in:
        encrypted = f_in.read()
    decrypted = f.decrypt(encrypted)
    return json.loads(decrypted.decode())

def print_menu():
    print("\n=== Password Manager ===")
    print("1. Visualizza account")
    print("2. Visualizza password")
    print("3. Aggiungi account")
    print("4. Modifica account")
    print("5. Elimina account")
    print("6. Esci")

def list_accounts(data):
    if not data["accounts"]:
        print("Nessun account salvato.")
        return
    for i, acc in enumerate(data["accounts"], start=1):
        print(f"{i}. {acc['site']} - {acc['username']}")

def view_password(data):
    if not data["accounts"]:
        print("Nessun account salvato.")
        return
    for i, acc in enumerate(data["accounts"], start=1):
        print(f"{i}. {acc['site']} - {acc['username']}")
    try:
        idx = int(input("Seleziona account per vedere la password: ")) - 1
        if idx < 0 or idx >= len(data["accounts"]):
            print("Scelta non valida.")
            return
    except ValueError:
        print("Input non valido.")
        return
    # Qui puoi chiedere un’ulteriore conferma/master password se vuoi
    print(f"Password per {data['accounts'][idx]['site']}: {data['accounts'][idx]['password']}")

def add_account(data):
    site = input("Sito: ")
    username = input("Username: ")
    password = getpass.getpass("Password: ")
    data["accounts"].append({
        "site": site,
        "username": username,
        "password": password
    })
    print("Account aggiunto!")

def modify_account(data):
    list_accounts(data)
    if not data["accounts"]:
        return
    try:
        idx = int(input("Seleziona account da modificare (numero): ")) - 1
        if idx < 0 or idx >= len(data["accounts"]):
            print("Scelta non valida.")
            return
    except ValueError:
        print("Input non valido.")
        return
    
    acc = data["accounts"][idx]
    print(f"Modifica account {acc['site']} - {acc['username']}")
    site = input(f"Sito ({acc['site']}): ") or acc['site']
    username = input(f"Username ({acc['username']}): ") or acc['username']
    password = getpass.getpass("Password (lascia vuoto per mantenere): ")
    if not password:
        password = acc['password']

    data["accounts"][idx] = {
        "site": site,
        "username": username,
        "password": password
    }
    print("Account modificato!")

def delete_account(data):
    list_accounts(data)
    if not data["accounts"]:
        return
    try:
        idx = int(input("Seleziona account da eliminare (numero): ")) - 1
        if idx < 0 or idx >= len(data["accounts"]):
            print("Scelta non valida.")
            return
    except ValueError:
        print("Input non valido.")
        return

    acc = data["accounts"].pop(idx)
    print(f"Account {acc['site']} eliminato!")

def main():
    salt = load_salt()
    master_password = getpass.getpass("Inserisci la master password: ")
    key = derive_key(master_password, salt)
    try:
        data = load_data(key)
    except Exception:
        print("Master password errata o dati corrotti.")
        return

    while True:
        print_menu()
        scelta = input("Scegli un'opzione: ")
        if scelta == "1":
            list_accounts(data)
        elif scelta == "2":
            view_password(data)
        elif scelta == "3":
            add_account(data)
            save_data(data, key)
        elif scelta == "4":
            modify_account(data)
            save_data(data, key)
        elif scelta == "5":
            delete_account(data)
            save_data(data, key)
        elif scelta == "6":
            print("Esco...")
            break
        else:
            print("Scelta non valida, riprova.")

if __name__ == "__main__":
    main()
