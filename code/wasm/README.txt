How to start?
You need emscripten to compile c code to a webassembly binary (.wasm).
To install a portable version of emscripten, you can execute the script "install_emscripten_portable.sh".
The script will create a folder named "emsdk-portable"(size ~1.3GB) in the current working directory.
To setup the PATH variable you can execute "source WORKINGDIR/emsdk-portable/emsdk_env.sh" or add this command to your .bashrc file. (Test: Execute "emcc" and you should get the error message "WARNING:root:no input files")
Use the script "prime_probe/.vscode/compile.sh" to compile the code in the "prime_probe" folder (The used command line arguments for emcc are described here: https://kripken.github.io/emscripten-site/docs/tools_reference/emcc.html).

To start the App execute "eviction_set_finder_START_ME.html" in Google Chrome or Firefox. The attack relies on SharedArrayBuffers, therefore make sure your browser configuration supports this feature (for more information read "enable_SAB_browser.txt").
