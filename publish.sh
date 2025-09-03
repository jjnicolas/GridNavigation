#!/bin/bash

# GridNavigation Swift Package Publishing Script
# Run this after creating the GitHub repository at https://github.com/jjnicolas/GridNavigation

echo "🚀 Publishing GridNavigation Swift Package to GitHub..."

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Package.swift not found. Make sure you're in the GridNavigation directory."
    exit 1
fi

# Check if remote is already added
if git remote get-url origin > /dev/null 2>&1; then
    echo "✅ Remote origin already configured"
else
    echo "📡 Adding GitHub remote..."
    git remote add origin https://github.com/jjnicolas/GridNavigation.git
fi

# Push to GitHub
echo "📤 Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Successfully published GridNavigation to GitHub!"
    echo ""
    echo "📦 Your package is now available at:"
    echo "   https://github.com/jjnicolas/GridNavigation"
    echo ""
    echo "📚 To use in Xcode projects:"
    echo "   1. File → Add Package Dependencies..."
    echo "   2. Enter: https://github.com/jjnicolas/GridNavigation"
    echo "   3. Choose version and add to target"
    echo ""
    echo "🏷️  To create a release tag:"
    echo "   git tag v1.0.0"
    echo "   git push origin v1.0.0"
    echo ""
else
    echo "❌ Failed to push to GitHub. Make sure:"
    echo "   1. You've created the repository at https://github.com/jjnicolas/GridNavigation"
    echo "   2. You have push permissions to the repository"
    echo "   3. You're authenticated with GitHub"
fi