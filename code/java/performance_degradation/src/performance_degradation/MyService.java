//Mehmet's SplitLock
package performance_degradation;

//package zagmobdev.degrader;
//
//import android.app.Service;
//import android.content.Intent;
//import android.os.IBinder;
//import android.app.usage.UsageStats;
//import android.app.usage.UsageStatsManager;
//import android.content.Context;
//import android.os.Handler;
//import android.util.Log;
//import android.widget.Toast;
import java.util.List;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicIntegerArray;
//import static zagmobdev.degrader.SelectionActivity.selected_app;
//import static zagmobdev.degrader.SelectionActivity.switchOn;

public class MyService{ //extends Service {
//    public Context context = this;
    //public Handler handler = null;
    public static Runnable runnable = null;

//    String[] detection = {"NOT running"};
    int recent_period = 1000; // ne kadar eskiye bakiyoruz FG check icin
    long[] currentTime = new long[1];

//    @Override
//    public IBinder onBind(Intent intent) {
//        // TODO: Return the communication channel to the service.
//        throw new UnsupportedOperationException("Not yet implemented");
//    }
//
//    @Override
//    public void onCreate(){
//        Log.e("Tag", "== Entered MyService onCreate - this should run only once!");
//    }   // onCreate close
//
//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {
//        // Let it continue running until it is stopped.
////        Toast.makeText(this, "MyService Started", Toast.LENGTH_SHORT).show();
//        Log.e("Tag", "== Entered MyService onStartCommand");
////        Toast.makeText(this, "Service created!", Toast.LENGTH_SHORT).show();
//
//        final Boolean[] isActive = {Boolean.FALSE};
//        final Boolean[] started = {Boolean.FALSE};
//        final Boolean[] oldstarted = {Boolean.FALSE};
//
//        //started[0] = Boolean.FALSE;
//        //started[1] = Boolean.FALSE;
//
//        handler = new Handler();
//        runnable = new Runnable() {
//            public void run() {
//                oldstarted[0] = started[0];
//                started[0] = myDetect();
//
////                isActive[0] = started[0] && !oldstarted[0];
//                if (started[0] && !oldstarted[0]){
//                    isActive[0] = Boolean.TRUE;
////                    isActive[0] = !isActive[0];
//                    Log.e("Tag","**************** \t isActive Switched from False to True");
//                }
//
////                Log.e("Tag","isRunning: " + started[0] + "\t switchOn: " + SelectionActivity.switchOn + "\t isActive: " + isActive[0] );
//                if (isActive[0]){
////                    Log.e("Tag","isRunning: " + started[0] + "\t switchOn: " + SelectionActivity.switchOn + "\t isActive: " + isActive[0] );
//                    lock();
////                    Log.e("Tag","\t isActive: " + isActive[0] );
//                    oldstarted[0] = started[0];
//                    started[0] = myDetect();
////                    isActive[0] = !started[0] || oldstarted[0];
//
//                    if (started[0] && !oldstarted[0]){
////                        isActive[0] = !isActive[0];
//                        isActive[0] = Boolean.FALSE;
////                        oldstarted[0] = Boolean.TRUE;
//                        Log.e("Tag","\t isActive Switched from True to False ****************");
//                    }
//                }
//                if(switchOn) {handler.postDelayed(runnable, 100); }
//            }
//        }; //  to make it continuous
//          handler.postDelayed(runnable, 100);    // the initial delay
//        return START_NOT_STICKY;
//    }

//    @Override
//    public void onDestroy() {
////  TODO: Temizle burayi daha sonra, gereksiz call'lari kapat
//        super.onDestroy();
//        this.stopSelf();
//        super.stopSelf();
//        super.stopService(new Intent(this, MyService.class));
//        Intent stopper = new Intent(this, MyService.class);
//        this.stopService(stopper);
//        Toast.makeText(this, "Service Destroyed", Toast.LENGTH_SHORT).show();
//        stopService(new Intent(getBaseContext(), MyService.class));
//        stopService(new Intent(this, MyService.class));
//        Log.e("service","onDestroy girdi");
//    }

    public void lock(){
        long startTime, endTime, lock_time;
        int arr_length = 1000*1024;
        int step_size = 1024;
        int threshold = 5000;
        int start_index = 0;
        long average_time = 0;
        long[] myTime = new long [arr_length];
        int[] value = new int [arr_length];
        int i;
        int[] uncacheable_addr = new int[arr_length];
        Random myrandom = new Random(761);
        AtomicInteger atint = new AtomicInteger();
        atint.set(5);
        AtomicIntegerArray at_int_arr = new AtomicIntegerArray(arr_length);
        at_int_arr.getAndIncrement(1);

        ///////////////////////     lock block     ///////////////////////
        lock_time = System.nanoTime();
        for (i = start_index; i < arr_length; i = i + step_size) {
            startTime = System.nanoTime();
            //value[i]  = bb.getInt(i);
            value[3] = at_int_arr.getAndIncrement(i);
            endTime = System.nanoTime();
            myTime[i] = endTime - startTime;
        }
        lock_time = System.nanoTime() - lock_time;

        for (i=0;i<arr_length ;i = i + step_size) {
            if (myTime[i]>threshold) {
                System.err.format("Index\t%d \tAccess Time: %d nanoseconds\n", i, myTime[i]);
        	//Log.e("tag" + "Index\t" + i + " \tAccess Time: " + myTime[i] );

                average_time = average_time + myTime[i];
            }
        }

        lock_time = lock_time/1000000 ; // converting to milliseconds
        System.err.format("Locking Took:	 " + lock_time + "\t milliseconds in total");
        //Log.e("Tag", "Locking Took:	 " + lock_time + "\t milliseconds in total");

             System.err.format("\n" + "Each Lock Took:\t " + average_time/arr_length + "\t microseconds in average\n");

    }   // lock close

//    public boolean myDetect(){
//        boolean status;
//        ///////////////////////     detection block     ///////////////////////
//        UsageStatsManager mUsageStatsManager =
//                (UsageStatsManager) getSystemService(Context.USAGE_STATS_SERVICE);
//        currentTime[0] = System.currentTimeMillis();
//        List<UsageStats> stats = mUsageStatsManager.queryUsageStats
//                (UsageStatsManager.INTERVAL_DAILY, currentTime[0] - 3000, currentTime[0]);
//        // Check only the last 10 seconds of running apps.
////        detection[0] = "not RUNNING!";
//        status = Boolean.FALSE;
//
//        for (UsageStats usageStats : stats) {
//            if (usageStats.getPackageName().equals(selected_app)
//                    && usageStats.getLastTimeUsed() > (currentTime[0] - recent_period)) {
// //               detection[0] = "RUNNING!";
//                status = Boolean.TRUE;
//            }
//        }
////        Log.e("Tag", "Target app " + selected_app + " is " + detection[0]);
////        Toast.makeText(context, "Target app is " + detection[0], Toast.LENGTH_SHORT).show();
//        return status;
//    }   // myDetect close

}
