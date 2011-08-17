# ~/.zlogin

# KeyChain ( Loading DSA and RSA keys )
if [[ -f ~/.ssh/id_rsa ]]; then
    # exporting SSH_* variables
    eval `keychain --quiet --eval id_rsa`
fi

# EOF
