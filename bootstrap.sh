TEMPLATES_PATH="/Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File Templates"

sudo rm -rf "$TEMPLATES_PATH/Walutator Templates"

sudo mkdir "$TEMPLATES_PATH/Walutator Templates"

sudo cp -a "Templates/." "$TEMPLATES_PATH/Walutator Templates"
