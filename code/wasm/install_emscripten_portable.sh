# https://emscripten.org/docs/getting_started/downloads.html
# Get the emsdk repo
git clone https://github.com/emscripten-core/emsdk.git

# Enter that directory
cd emsdk

# Download and install the latest SDK tools.
./emsdk install sdk-1.38.11-64bit

# Make the "latest" SDK "active" for the current user. (writes ~/.emscripten file)
./emsdk activate sdk-1.38.11-64bit

# Activate PATH and other environment variables in the current terminal
source ./emsdk_env.sh
