#!/bin/bash

# Base directory where all your projects are
BASE_DIR="/Users/apple/dummy_vapp"

# Starting port
PORT=5000

# Install serve globally if not already installed
if ! command -v serve &> /dev/null
then
    echo "Installing serve..."
    npm install -g serve
fi

# Kill all old pm2 processes for a clean start
pm2 delete all

# Loop through all subfolders (projects) in dummy_vapp
for PROJECT in "$BASE_DIR"/*; do
    if [ -d "$PROJECT" ]; then
        cd "$PROJECT" || continue

        # Skip unwanted folders
        case "$(basename "$PROJECT")" in
            .git|node_modules)
                continue
                ;;
        esac

        if [ -f "package.json" ]; then
            echo "📦 Building project: $(basename "$PROJECT")"

            # Build project (ignore errors if no build script)
            npm run build || echo "⚠️ No build script in $(basename "$PROJECT")"

            # Detect build folder
            if [ -d "build" ]; then
                BUILD_DIR="build"
            elif [ -d "dist" ]; then
                BUILD_DIR="dist"
            else
                echo "⚠️ No build/dist folder found in $(basename "$PROJECT")"
                continue
            fi

            # Start with PM2
            echo "🚀 Starting $(basename "$PROJECT") on port $PORT"
            pm2 start serve --name "$(basename "$PROJECT")" -- -s $BUILD_DIR -l $PORT

            # Increment port for next project
            PORT=$((PORT+1))
        fi
    fi
done

# Save PM2 processes so they auto-start on reboot
pm2 save --force

echo "✅ All valid projects started. Run 'pm2 list' to check status."
