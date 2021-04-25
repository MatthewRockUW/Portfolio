import java.util.*;
import java.io.*;

public class ThreadHeap extends Thread {

	private int n; //buildings
	private int[] path;
	private ArrayList<ArrayList<Integer>> generatedpaths;
	
    public ThreadHeap(int n, int[] path){
		this.n = n;
		this.path = path;
		this.generatedpaths = new ArrayList<ArrayList<Integer>>();
    }
	
	public void run(){
		//System.out.println(Arrays.toString(path));
		RunningHeap(n, path);
		//System.out.println(generatedpaths.size());
		bestPath();
	}
	
	private void RunningHeap(int k, int[] path) {
		if (k == 1){
			ArrayList<Integer> conversionpath = new ArrayList<Integer>();
			for(int temppathing : path){
				conversionpath.add(temppathing);
			}
			generatedpaths.add(conversionpath);
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
	
	public ArrayList getPaths(){
		return generatedpaths;
	}
	
	public void bestPath(){
		Building campus = Building.getInstance();
		ArrayList<ArrayList<Integer>> bestpaths = new ArrayList<ArrayList<Integer>>();
		ArrayList<ArrayList<Integer>> pathtimes = campus.getPaths();
		int besttime = campus.returnBestTime();
		for(ArrayList<Integer> thispath : generatedpaths){
			ArrayList<Integer> conversionpath = new ArrayList<Integer>();
			int currentspot = 0;
			int nextspot = 0;
			int currenttime = 0;
			for(int temppathing : thispath){
				nextspot = temppathing;
				currenttime += pathtimes.get(currentspot).get(nextspot);
				conversionpath.add(temppathing);
				currentspot = nextspot;
			}
			currenttime += pathtimes.get(currentspot).get(0);
			if(currenttime == besttime){
				bestpaths.add(conversionpath);
			}
			else if(currenttime < besttime){
				besttime = currenttime;
				bestpaths.clear();
				bestpaths.add(conversionpath);
			}
		}
		campus.bestPathSubmission(bestpaths, besttime);
		generatedpaths = null;
	}
}