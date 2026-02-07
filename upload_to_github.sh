#!/bin/bash
# AetherOS GitHub Upload Script
# This script will upload all files to your GitHub repository

set -e  # Exit on error

echo "🌌 AetherOS GitHub Upload Script"
echo "=================================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install git first."
    exit 1
fi

# Repository URL
REPO_URL="https://github.com/Richard-JHLee/aetherOS.git"
REPO_DIR="aetherOS"

echo "📦 Step 1: Clone or update repository"
echo "--------------------------------------"

if [ -d "$REPO_DIR" ]; then
    echo "✅ Repository directory exists. Pulling latest changes..."
    cd "$REPO_DIR"
    git pull origin main || git pull origin master
else
    echo "📥 Cloning repository..."
    git clone "$REPO_URL"
    cd "$REPO_DIR"
fi

echo ""
echo "📂 Step 2: Create directory structure"
echo "--------------------------------------"

# Create directories
mkdir -p core ui docs brand scripts

# Create placeholder README files
echo "# AetherOS Core Engine" > core/README.md
echo "# User Interface Components" > ui/README.md
echo "# Documentation" > docs/README.md
echo "# Brand Assets (Logos, Colors)" > brand/README.md
echo "# Utility Scripts" > scripts/README.md

echo "✅ Directories created"

echo ""
echo "📝 Step 3: Create LICENSE file"
echo "--------------------------------------"

cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 Richard-JHLee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

echo "✅ LICENSE created"

echo ""
echo "📋 Step 4: Check for required files"
echo "--------------------------------------"

REQUIRED_FILES=("README.md" "PHILOSOPHY.md" "aether.py" "requirements.txt" ".gitignore")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo "⚠️  Missing files detected:"
    for file in "${MISSING_FILES[@]}"; do
        echo "   - $file"
    done
    echo ""
    echo "Please create these files in the current directory before running this script."
    echo "You can copy them from the artifacts provided."
    exit 1
else
    echo "✅ All required files present"
fi

echo ""
echo "🔧 Step 5: Git configuration"
echo "--------------------------------------"

# Check git user configuration
if [ -z "$(git config user.name)" ]; then
    echo "⚠️  Git user.name not set"
    read -p "Enter your name: " git_name
    git config user.name "$git_name"
fi

if [ -z "$(git config user.email)" ]; then
    echo "⚠️  Git user.email not set"
    read -p "Enter your email: " git_email
    git config user.email "$git_email"
fi

echo "✅ Git configured as: $(git config user.name) <$(git config user.email)>"

echo ""
echo "➕ Step 6: Add files to git"
echo "--------------------------------------"

git add .
echo "✅ Files staged for commit"

echo ""
echo "💾 Step 7: Commit changes"
echo "--------------------------------------"

COMMIT_MESSAGE="feat: Initial commit - AetherOS v0.1.0

- Add project README with philosophy and roadmap
- Add PHILOSOPHY.md documenting core principles
- Add aether.py prototype with basic intent parsing
- Add requirements.txt for dependencies
- Set up project structure (core, ui, docs, brand, scripts)
- Add MIT License

This is the foundational release of AetherOS, an intent-driven
AI operating system focused on privacy, efficiency, and simplicity.

Invisible Intelligence, Everywhere."

git commit -m "$COMMIT_MESSAGE"
echo "✅ Changes committed"

echo ""
echo "🚀 Step 8: Push to GitHub"
echo "--------------------------------------"

echo "Pushing to GitHub..."
if git push origin main 2>/dev/null; then
    echo "✅ Successfully pushed to main branch"
elif git push origin master 2>/dev/null; then
    echo "✅ Successfully pushed to master branch"
else
    echo "❌ Push failed. You may need to authenticate."
    echo ""
    echo "Try one of these:"
    echo "1. Set up GitHub CLI: gh auth login"
    echo "2. Use personal access token"
    echo "3. Set up SSH keys"
    exit 1
fi

echo ""
echo "✅ Upload complete!"
echo ""
echo "🎉 Success! Your repository is now updated:"
echo "   $REPO_URL"
echo ""
echo "📋 Next steps:"
echo "1. Visit your repository on GitHub"
echo "2. Check that all files are uploaded correctly"
echo "3. Add repository description and topics in Settings"
echo "4. Consider creating your first release (v0.1.0)"
echo ""
echo "Thank you for building AetherOS! 🌌"
