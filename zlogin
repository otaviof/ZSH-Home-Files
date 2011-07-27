# ~/.zlogin

# KeyChain ( Loading DSA and RSA keys )
if [[ -f ~/.ssh/id_rsa ]]; then
    # exporting SSH_* variables
    eval `keychain --eval id_rsa`
fi

# EOF
