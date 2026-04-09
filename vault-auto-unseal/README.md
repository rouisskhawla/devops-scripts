# Vault Auto-Unseal

Simple setup to automatically unseal Vault after a restart so you don’t have to do it manually every time.

## Scripts

- [`vault-unseal.sh`](./vault-unseal.sh)

---

## What this does

- Waits for Vault to become available  
- Checks if Vault is already unsealed  
- If sealed, uses stored unseal keys to unseal it automatically  

**Used in:** [`redis-vault-spring-boot`](https://github.com/rouisskhawla/redis-vault-spring-boot) — a secure service deployment using HashiCorp Vault for secrets management

---

## Configuration

### 1. Listener (TLS enabled)

**`/etc/vault.d/vault.hcl`**

```hcl
listener "tcp" {
  address        = "0.0.0.0:8200"
  tls_cert_file  = "/opt/vault/tls/tls.cert"
  tls_key_file   = "/opt/vault/tls/tls.key"
}
````

* Vault runs on port `8200` with TLS enabled
* Self-signed cert with SANs (IP + localhost)

TLS files:

```text
/opt/vault/tls/
├── tls.cert
├── tls.key
└── tls.crt
```

---

### 2. Environment Variables

**`/etc/vault.d/vault.env`**

```bash
VAULT_ADDR=https://192.168.1.8:8200
VAULT_CACERT=/opt/vault/tls/tls.cert
```

---

### 3. Unseal Keys

**`/opt/vault/unseal_keys.txt`**

```text
unseal-key-1
unseal-key-2
unseal-key-3
```

* Only readable by `vault` user (`-rw-------`)
* Required to unseal Vault

---

### 4. Auto-Unseal Script

* Waits for Vault to be ready
* Skips if already unsealed
* Applies unseal keys one by one

---

### 5. systemd Service

**`/etc/systemd/system/vault-auto-unseal.service`**

```ini
[Unit]
Description=Vault Auto Unseal
After=vault.service
PartOf=vault.service

[Service]
Type=oneshot
User=vault
Group=vault
EnvironmentFile=/etc/vault.d/vault.env
ExecStart=/opt/vault/auto-unseal.sh

[Install]
WantedBy=vault.service
```

* Runs automatically after Vault starts
* Ensures Vault is always unsealed after reboot

## Vault Auto-Unseal After Restart

These screenshots show Vault automatically unsealed after a server or service restart using the `vault-unseal.sh` script.

### Vault Status After Restart (Command Line)
![Vault Unsealed](/docs/screenshots/vault-unsealed-cmd.png)

### Vault Status After Restart (UI)
![Vault Unsealed](/docs/screenshots/vault-unsealed-ui.png)
---

##  Why this is useful

* Removes manual unseal steps after restart
* Helps with faster recovery and uptime
* Useful for automated environments

