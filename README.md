# SSH Key Installer

A small, safe Bash script that adds a **public** SSH key to `~/.ssh/authorized_keys`, so you can log in without a password.

*Deutsch: siehe unten.*

## Usage
```bash
chmod +x setup-ssh-key.sh
./setup-ssh-key.sh                                  # prompts for the key
./setup-ssh-key.sh "ssh-ed25519 AAAA... comment"    # key as argument
./setup-ssh-key.sh -f ~/.ssh/id_ed25519.pub         # key from a file
echo "ssh-ed25519 AAAA..." | ./setup-ssh-key.sh     # key from stdin
```
Set `SSH_DIR` to use another directory than `~/.ssh`.

## What it does
- creates `~/.ssh` (mode 700) and `authorized_keys` (mode 600) if missing
- checks that the input is a valid OpenSSH public key (and with `ssh-keygen`, if available)
- **refuses private keys**
- skips keys that are already installed (no duplicates)
- makes sure the last line ends with a newline, so an existing key is never corrupted
- needs only Bash, no other dependencies

## License
MIT, see [LICENSE](LICENSE).

---

# SSH-Key-Installer

Kleines, sicheres Bash-Skript, das einen **öffentlichen** SSH-Schlüssel in `~/.ssh/authorized_keys` einträgt, damit du dich ohne Passwort anmelden kannst.

## Benutzung
```bash
chmod +x setup-ssh-key.sh
./setup-ssh-key.sh                                  # fragt nach dem Schlüssel
./setup-ssh-key.sh "ssh-ed25519 AAAA... Kommentar"  # Schlüssel als Argument
./setup-ssh-key.sh -f ~/.ssh/id_ed25519.pub         # Schlüssel aus Datei
echo "ssh-ed25519 AAAA..." | ./setup-ssh-key.sh     # Schlüssel über stdin
```
Mit `SSH_DIR` lässt sich ein anderes Verzeichnis als `~/.ssh` angeben.

## Was es macht
- legt `~/.ssh` (Modus 700) und `authorized_keys` (Modus 600) an, falls sie fehlen
- prüft, ob die Eingabe ein gültiger OpenSSH-Public-Key ist (zusätzlich mit `ssh-keygen`, falls vorhanden)
- **lehnt private Schlüssel ab**
- überspringt bereits eingetragene Schlüssel (keine Duplikate)
- sorgt für ein Zeilenende am Dateiende, damit ein vorhandener Schlüssel nicht beschädigt wird
- braucht nur Bash

## Lizenz
MIT, siehe [LICENSE](LICENSE).
