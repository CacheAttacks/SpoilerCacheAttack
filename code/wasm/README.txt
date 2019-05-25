-How to start?
It is advisable to use the local webserver from emscripten to run the code in order to avoid some browser origin restrictions. You also need emscripten to compile c code to a webassembly binary (.wasm).
To install a portable version of emscripten, you can execute the script "install_emscripten_portable.sh" (Windows users should use the file "install_emscripten_portable.ps" in combination with powershell).
See also https://emscripten.org/docs/getting_started/downloads.html for help. 
If you have already installed emscripten or want to install it manually be aware that this code is tested with emscripten version sdk-1.38.11-64bit.
The script will create a folder named "emsdk-portable"(size ~1.3GB) in the current working directory.

-How to run the code?
The repository already contains a runnable .wasm file. If you want to compile the code by yourself jump to the section "How to compile the code".
It is advisable to use the local webserver from emscripten to avoid some browser origin restrictions. To start the webserver with "prime_probe" as the root directory execute "WORKINGDIR/emsdk-portable/emscripten/1.38.11/emrun --no_browser --port 8080 REPOS/code/wasm/prime_probe".
To start the App execute "http://localhost:8080/eviction_set_finder_START_ME.html" in Google Chrome or Firefox. The attack relies on SharedArrayBuffers, therefore make sure your browser configuration supports this feature (for more information read "enable_SAB_browser.txt").

-How to compile the code?
To setup the PATH variable you can execute "source WORKINGDIR/emsdk-portable/emsdk_env.sh" or add this command to your .bashrc file. (Test: Execute "emcc" and you should get the error message "WARNING:root:no input files")
Use the script "prime_probe/.vscode/compile.sh" to compile the code in the "prime_probe" folder (The used command line arguments for emcc are described here: https://kripken.github.io/emscripten-site/docs/tools_reference/emcc.html).

-How to run the demo with plots?
If you want to use R to plot the observed mem accesses install the package plumber via the command "install.packages("plumber")".
Afterwards you should set your working directory with "setwd("REPOS/code/r/prime_probe/")" first.
Now you can start the plumber server with the command "plumber::plumb("plumber.R")$run(port=8000)".
The server is now waiting for incoming requests (in our case from JS).
