# PNG-to-ICNS-Converter-macOS
<p align="center">
    <img width="1728" alt="Screenshot 2025-04-05 at 3 14 30 AM" src="https://github.com/user-attachments/assets/5a62ebba-0461-4973-b118-f32a5fe69ce8" />
</p>

If you'd like to manually create the automaton.
<ol>
    <li>Open the <code>Automator</code> application<br><br></li>
    <li>Click <code>Quick Action</code> then <img src="https://github.com/user-attachments/assets/af48bc2d-fe23-44e2-88f5-3cd5b5e4e9f5" width="60"/><br><br></li>
    <li>
        Select: <sub><sup>(in the top right side at the top)</sup></sub>
        <ol>
            <li>Workflow receives current: <code>image files</code></li>
        </ol>
        <br>
    </li>
    <li>
        Add Action(s): <sub><sup>(from the left sidebar drag & and drop it to right side)</sup></sub>
        <ol>
            <li>
                <code>File & Folders</code> > <code>Copy Finder Items</code>
                <br>
                Select:
                <ul>
                    <li>to: Select this folder <code>PNG to ICNS</code> <sub><sup>(Path should be: ~/Documents/Automator/"PNG to ICNS", if the folder doesn't exists then create it first)</sup></sub></li>
                </ul>
                <br><br>
            </li>
            <li>
                <code>Photos</code> > <code>Scale Images</code> <sub><sup>(place it to under <code>Copy Finder Items</code>)</sup></sub>
                <br>
                Enter Value:
                <ul>
                    <li>To Size (pixels): <code>1024</code> </li>
                </ul>
                <br><br>
            </li>
            <li>
                <code>Utilities</code> > <code>Run Shell Script</code> <sub><sup>(place it to under <code>Scale Images</code>)</sup></sub>
                <br>
                Select:
                <ul>
                    <li>Shell: <code>/bin/bash</code></li>
                    <li>Pass Input: <code>to stdin</code></li>
                </ul>
                <br>
                Code (shell): <a href="#code-shell">Copy from here</a> 
                <br><br>
            </li>
            <li>
                <code>Utilities</code> > <code>Watch Me Do</code> <sub><sup>(place it to under <code>Run Shell Script</code>, it's not necessary and not required, but you can add it in order debug and check which event(s) were triggered)</sup></sub>
            </li>
        </ol>
        <br><br>
    </li>
    <li>From the top menu bar, click on <br>
        <code>File</code> > <code>Save</code> and name it <code>PNG to ICNS</code>
        <br><sub><sup>OR</sup></sub><br>
        <code>File</code> > <code>Export</code> and name it <code>PNG to ICNS</code> to save it as a workflow file if you want to use it later.
        <br><br>
    </li>
    <li>
        If you export it as a workflow file, then you can run it by double-clicking the file and then clicking <code>Install</code> to install it.
        <br>
        <img src="https://github.com/user-attachments/assets/72d1fc83-4717-4bf7-b92f-0d0bd0e5c2b6" width="400"/>
        <br><br>
    </li>
    <li>
        Now you can use it by right-clicking on any PNG file and selecting <code>Quick Actions</code> > <code>PNG to ICNS</code>
        <br>
        <img src="https://github.com/user-attachments/assets/6162d775-8124-4077-9e00-40baf01060de" width="250"/>
        <br><br>
    </li>
    <li>The PNG file will be converted to ICNS format and saved in the <code>PNG to ICNS</code> folder <sup><sub><code>~/Documents/Automator/"PNG to ICNS"</code></sub></sup></li>
</ol>

### Code (shell)
```bash
#!/bin/bash
# Functions
update_basename_if_exists() {
  local basename="$1"
  local extension="icns"
  local original_basename="$basename"
  local count=1

  # Loop until a unique name is found
  while [ -e "${basename}.${extension}" ]; do
    basename="${original_basename} - $count"
    ((count++))
  done

  echo "$basename"
}

# Go to the Target Directory (create if it doesn't exist)
TARGET_DIR=~/Documents/Automator/"PNG to ICNS"
mkdir -p "$TARGET_DIR" && cd "$TARGET_DIR" 

# Read the input file path from stdin
# read INPUT_FILE
while IFS= read -r INPUT_FILE; do
    # Extract the basename (without extension) for use in folder and output file names
    BASENAME=$(basename "$INPUT_FILE" .png)
    ORIGINAL_BASENAME="$BASENAME"


    # Check if the input file (BASENAME.icns) exists then update BASENAME with the new name
    if [ -e "${BASENAME}.icns" ]; then
    BASENAME=$(update_basename_if_exists "$BASENAME")
    fi




    # Create a folder for the iconset
    ICONSET_FOLDER="${BASENAME}.iconset"
    mkdir "$ICONSET_FOLDER"

    # Resize the images and create the iconset
    sips -z 16 16     "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_16x16.png"
    sips -z 32 32     "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_16x16@2x.png"
    sips -z 32 32     "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_32x32.png"
    sips -z 64 64     "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_32x32@2x.png"
    sips -z 128 128   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_128x128.png"
    sips -z 256 256   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_128x128@2x.png"
    sips -z 256 256   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_256x256.png"
    sips -z 512 512   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_256x256@2x.png"
    sips -z 512 512   "$INPUT_FILE" --out "${ICONSET_FOLDER}/icon_512x512.png"

    # Copy the 512x512 image to create the @2x version
    cp "$INPUT_FILE"  "${ICONSET_FOLDER}/icon_512x512@2x.png"

    # Remove the original image
    rm -rf "${ORIGINAL_BASENAME}.png"

    # Create the .icns file
    iconutil -c icns "${ICONSET_FOLDER}"

    # Remove the temporary folder
    rm -R "${ICONSET_FOLDER}"
done 
```
