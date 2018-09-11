package performance_degradation;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicIntegerArray;

public class PerformanceDegradation {
	public static void main(String[] args) {
		int arr_length = 1024*100;
		AtomicIntegerArray arr = new AtomicIntegerArray(arr_length);
		Map<Integer, Long> m1 = new HashMap<Integer, Long>();
		measurement(arr, m1);
		Map<Integer, Long> m2 = new HashMap<Integer, Long>();
		measurement(arr, m2);
		for(Object key:m1.keySet()) {
			if(m2.containsKey(key)) {
				System.out.println(Integer.toHexString((int)key) + " " + m1.get(key) + ":" + m2.get(key));
			}
			
		}
	}

	public static int measurement(AtomicIntegerArray arr, Map<Integer, Long> map) {
		int time_arr_size = 10;
		long operationTime[] = new long[time_arr_size];
		int value = 0;
		String output = "";
		for(int i=0; i<arr.length(); i++){
			long startTime = System.nanoTime();
			value = arr.getAndIncrement(i);
			long time = System.nanoTime() - startTime;
			//if(time_over_mean(time, operationTime)) {
			if(time > 200) {
				output += Integer.toHexString(i) + ":" + time + " ";
				map.put(i, time);
			}
			operationTime[i % time_arr_size] = time;
			
			
		}
		System.out.println(output);
		return value;
	}
	
	public static boolean time_over_mean(long valueToCheck, long operationTime[]) {
		long mean=0, div=operationTime.length;
		for(int i=0;i<operationTime.length;i++) {
			if(operationTime[i] == 0) {
				div--;
				continue;
			}
			mean += operationTime[i];
		}
		if(div == 0)
			return false;
		else
			return valueToCheck > 1.5 * mean / div;
	}
}
