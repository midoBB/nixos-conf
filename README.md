# My WIP nixos configuration

## Steps

- Download git / git-crypt / gnupg / pinentry_qt and have gpg agent running
- Reboot and download the private keys to unlock the secrets.
- Do a gpg --import on the private key
- Enter the passphrase for the private key.
- Do a gpg --edit on the email
- Trust as ultimate
- Clone the repo git clone https://github.com/midoBB/nixos-conf.git
- Do a git crypt unlock
