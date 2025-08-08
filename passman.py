import os
import json
import base64
import tkinter as tk
from tkinter import messagebox, simpledialog
from tkinter import ttk
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

class PasswordDialog(simpledialog.Dialog):
    def __init__(self, parent, title, site="", username="", password=""):
        self.site = site
        self.username = username
        self.password = password
        super().__init__(parent, title)

    def body(self, master):
        tk.Label(master, text="Sito:").grid(row=0, sticky="w")
        tk.Label(master, text="Username:").grid(row=1, sticky="w")
        tk.Label(master, text="Password:").grid(row=2, sticky="w")

        self.site_entry = tk.Entry(master)
        self.site_entry.grid(row=0, column=1, sticky="ew")
        self.site_entry.insert(0, self.site)

        self.user_entry = tk.Entry(master)
        self.user_entry.grid(row=1, column=1, sticky="ew")
        self.user_entry.insert(0, self.username)

        self.pass_entry = tk.Entry(master, show="*")
        self.pass_entry.grid(row=2, column=1, sticky="ew")
        self.pass_entry.insert(0, self.password)

        master.grid_columnconfigure(1, weight=1)
        return self.site_entry

    def apply(self):
        self.site = self.site_entry.get().strip()
        self.username = self.user_entry.get().strip()
        self.password = self.pass_entry.get()

class LoginDialog(simpledialog.Dialog):
    def body(self, master):
        tk.Label(master, text="Master Password:").grid(row=0)
        self.pass_entry = tk.Entry(master, show="*")
        self.pass_entry.grid(row=0, column=1, sticky="ew")
        master.grid_columnconfigure(1, weight=1)
        return self.pass_entry

    def apply(self):
        self.result = self.pass_entry.get()

class PasswordManagerApp:
    def __init__(self, root, data, key):
        self.root = root
        self.data = data
        self.key = key
        root.title("Password Manager")

        # Usa grid nel root
        root.rowconfigure(0, weight=1)
        root.columnconfigure(0, weight=1)

        main_frame = ttk.Frame(root, padding=10)
        main_frame.grid(sticky="nsew")
        main_frame.rowconfigure(0, weight=1)
        main_frame.columnconfigure(0, weight=1)

        self.listbox = tk.Listbox(main_frame)
        self.listbox.grid(row=0, column=0, sticky="nsew")

        scrollbar = ttk.Scrollbar(main_frame, orient="vertical", command=self.listbox.yview)
        scrollbar.grid(row=0, column=1, sticky="ns")
        self.listbox.configure(yscrollcommand=scrollbar.set)

        btn_frame = ttk.Frame(main_frame)
        btn_frame.grid(row=1, column=0, columnspan=2, pady=10, sticky="ew")

        for i in range(5):
            btn_frame.columnconfigure(i, weight=1)

        ttk.Button(btn_frame, text="Visualizza Password", command=self.view_password).grid(row=0, column=0, padx=5, sticky="ew")
        ttk.Button(btn_frame, text="Aggiungi Account", command=self.add_account).grid(row=0, column=1, padx=5, sticky="ew")
        ttk.Button(btn_frame, text="Modifica Account", command=self.modify_account).grid(row=0, column=2, padx=5, sticky="ew")
        ttk.Button(btn_frame, text="Elimina Account", command=self.delete_account).grid(row=0, column=3, padx=5, sticky="ew")
        ttk.Button(btn_frame, text="Esci", command=root.quit).grid(row=0, column=4, padx=5, sticky="ew")

        self.refresh_list()

    def refresh_list(self):
        self.listbox.delete(0, tk.END)
        for acc in self.data["accounts"]:
            self.listbox.insert(tk.END, f"{acc['site']} - {acc['username']}")

    def get_selected_index(self):
        try:
            return self.listbox.curselection()[0]
        except IndexError:
            messagebox.showwarning("Seleziona un account", "Per favore, seleziona un account dalla lista.")
            return None

    def view_password(self):
        idx = self.get_selected_index()
        if idx is not None:
            acc = self.data["accounts"][idx]
            messagebox.showinfo("Password", f"Password per {acc['site']}:\n{acc['password']}")

    def add_account(self):
        dialog = PasswordDialog(self.root, "Aggiungi Account")
        if dialog.site and dialog.username and dialog.password:
            self.data["accounts"].append({
                "site": dialog.site,
                "username": dialog.username,
                "password": dialog.password
            })
            save_data(self.data, self.key)
            self.refresh_list()
            messagebox.showinfo("Successo", "Account aggiunto!")

    def modify_account(self):
        idx = self.get_selected_index()
        if idx is not None:
            acc = self.data["accounts"][idx]
            dialog = PasswordDialog(self.root, "Modifica Account", acc['site'], acc['username'], acc['password'])
            if dialog.site and dialog.username and dialog.password:
                self.data["accounts"][idx] = {
                    "site": dialog.site,
                    "username": dialog.username,
                    "password": dialog.password
                }
                save_data(self.data, self.key)
                self.refresh_list()
                messagebox.showinfo("Successo", "Account modificato!")

    def delete_account(self):
        idx = self.get_selected_index()
        if idx is not None:
            acc = self.data["accounts"].pop(idx)
            save_data(self.data, self.key)
            self.refresh_list()
            messagebox.showinfo("Eliminato", f"Account {acc['site']} eliminato.")

def main():
    salt = load_salt()

    root = tk.Tk()
    root.geometry("700x500")  # dimensione iniziale
    root.minsize(500, 400)    # dimensione minima

    root.withdraw()  # nasconde la finestra principale temporaneamente

    login_dialog = LoginDialog(root, "Login")
    master_password = login_dialog.result
    if not master_password:
        messagebox.showerror("Errore", "Devi inserire la master password.")
        return

    key = derive_key(master_password, salt)
    try:
        data = load_data(key)
    except Exception:
        messagebox.showerror("Errore", "Master password errata o dati corrotti.")
        return

    root.deiconify()  # mostra la finestra principale
    app = PasswordManagerApp(root, data, key)
    root.mainloop()

if __name__ == "__main__":
    main()
