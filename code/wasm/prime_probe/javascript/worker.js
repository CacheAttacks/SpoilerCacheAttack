self.addEventListener('message', (m) => {
  // Create an Int32Array on top of that shared memory area
  const sharedArray = new Uint32Array(m.data)
  // console.log("worker online\n");
  // sharedArray[0] = 1;
  // console.log("worker:" + sharedArray[0]);

  while (1) {
    sharedArray[0]++;
    // Atomics.add(sharedArray, 0, 1);
  }
});