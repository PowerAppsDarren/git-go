#!/bin/bash
# Fix git-go "command not found" issue

echo "🔧 Fixing git-go command..."

# 1. Clear bash hash table
hash -r

# 2. Create an alias as backup
if ! grep -q "alias git-go=" ~/.bashrc; then
    echo 'alias git-go="/home/darren/bin/git-go"' >> ~/.bashrc
    echo "✅ Added git-go alias to ~/.bashrc"
fi

# 3. Make sure the launcher exists and is correct
cat > ~/bin/git-go << 'EOF'
#!/bin/bash
exec "/home/darren/src/git-go/bin/git-go" "$@"
EOF
chmod +x ~/bin/git-go
echo "✅ Updated ~/bin/git-go launcher"

# 4. Test it works
if /home/darren/bin/git-go version >/dev/null 2>&1; then
    echo "✅ git-go is working!"
    echo
    echo "Now run ONE of these:"
    echo "  1. source ~/.bashrc"
    echo "  2. Open a new terminal"
    echo
    echo "Then 'git-go' will work!"
else
    echo "❌ Something's wrong with the git-go installation"
fi