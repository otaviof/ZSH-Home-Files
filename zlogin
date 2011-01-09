# ~/.zlogin

# KeyChain ( Loading DSA and RSA keys )
if [[ -f ~/.ssh/id_dsa && -f ~/.ssh/id_rsa ]]; then
    # exporting SSH_* variables
    eval `keychain -q --eval id_dsa id_rsa`
fi

# EOF
