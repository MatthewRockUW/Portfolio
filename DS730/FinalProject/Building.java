import java.util.*;
import java.io.*;

public class Building {
	
	private static Building single_building = null;
	private static ArrayList<ArrayList<Integer>> pathtimes;
	private static ArrayList<ArrayList<Integer>> bestpaths;
	private static ArrayList<String> buildings;
	private static int besttime;
	
	public static Building getInstance(){   
	if (single_building == null){
		single_building = new Building();   
		}
	return single_building;   
	}   
	
	private Building(){
		this.bestpaths = new ArrayList<ArrayList<Integer>>();
	}
	
	public void BuildingLoading(ArrayList<ArrayList<Integer>> pathtimes, ArrayList<String> buildings, int[] firstpath) {
		this.pathtimes = pathtimes;
		this.buildings = buildings;
		ArrayList<Integer> conversionpath = new ArrayList<Integer>();
		int currentspot = 0;
		int nextspot = 0;
		int currentbesttime = 0;
		for(int temppathing : firstpath){
			nextspot = temppathing;
			currentbesttime += pathtimes.get(currentspot).get(nextspot);
			conversionpath.add(temppathing);
			currentspot = nextspot;
		}
		currentbesttime += pathtimes.get(currentspot).get(0);
		this.besttime = currentbesttime;
	}
	
	public ArrayList<ArrayList<Integer>> getPaths(){
		return pathtimes;
	}
	
	public int returnBestTime(){
		return besttime;
	}
	
	public ArrayList<ArrayList<Integer>> returnBestPath(){
		return bestpaths;
	}
	
	public String[] returnBestBuildings(){
		String[] allpaths = new String[bestpaths.size()];
		int pathadding = 0;
		for(ArrayList<Integer> thispath : bestpaths){
			String buildingPath = buildings.get(0);
			for(int i = 0; i < thispath.size(); i++){
				buildingPath = buildingPath + " " + buildings.get(thispath.get(i));
			}
			buildingPath = buildingPath + " " + buildings.get(0) + " " + String.valueOf(besttime);
			allpaths[pathadding] = buildingPath;
			pathadding++;
		}
		return(allpaths);
	}
	
	public void bestPathSubmission(ArrayList<ArrayList<Integer>> submittedpath, int submittedtime){
		if(submittedtime == besttime){
			bestpaths.addAll(submittedpath);
		}			
		else if (submittedtime < besttime){
			besttime = submittedtime;
			bestpaths.clear();
			bestpaths.addAll(submittedpath);
		}
	}
}

