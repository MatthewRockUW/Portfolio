import java.util.*;
import java.io.*;

public class MainHeap {

	private int n; //buildings
	private int[] path;
	private ThreadHeap[] allthreads;
	private int threadCount;
	private static int cutoff = 9;
	private int threads = 8;
	
    public MainHeap(int n, int[] path){
		this.n = n;
		threadCount = 0;
		int factorial = 1;
		if(n <= cutoff){
			factorial = 1;
		}
		else{
			for(int i = n; i > cutoff; i--){
				factorial = factorial * i;
			}
		}
		allthreads = new ThreadHeap[factorial];
		RunningHeap(n, path);
		ThreadHeap[] currentthreads = new ThreadHeap[threads];
		for(int i = 1; i <= factorial; i++){
			currentthreads[(i-1) % threads] = allthreads[i-1];
			allthreads[i-1].run();
			if(i % threads == 0 | i == factorial){

				for(Thread runningthread : currentthreads){
					try{
						runningthread.join();
					}
					catch(Exception e){
						System.out.println("Thread catcher broke");
					}
				}
				for(Thread runningthread : currentthreads){
					runningthread = null;
					System.gc();
				}
			}			
		}		
    }
	
	private void RunningHeap(int k, int[] path) {
		if (k <= cutoff){
			int[] copypath = new int[n];
			for(int i = 0; i < n; i++){
				copypath[i] = path[i];
			}
			allthreads[threadCount] = new ThreadHeap(k, copypath);
			threadCount++;
		}
		else {
			RunningHeap(k-1, path);
			
			for(int i = 0; i < k-1; i+=1){
				if(k % 2 == 0){
					int temp = path[i];
					path[i] = path[k-1];
					path[k-1] = temp;
				}
				else{
					int temp = path[0];
					path[0] = path[k-1];
					path[k-1] = temp;
				}
				RunningHeap(k-1, path);
			}
		}
	}
}