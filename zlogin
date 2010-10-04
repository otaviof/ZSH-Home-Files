# ~/.zlogin

# KeyChain ( Loading DSA and RSA keys )
if [[ -f ~/.ssh/id_dsa && -f ~/.ssh/id_rsa ]]; then
    keychain            \
        --inherit any   \
        --confirm       \
        -q              \
        ~/.ssh/id_dsa   \
        ~/.ssh/id_rsa
fi

# EOF
