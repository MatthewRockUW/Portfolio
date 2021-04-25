import java.io.*;  //needed for File class below
import java.util.*;  //needed for Scanner class below
/*
OK - 1. recursively create all permutations
2. When the collection hits an arbitrary n, create a thread to check the times
3. Have that thread evaluate the smallest time and report it. 
*/

public class FinalRunner
{
    public static void main(String args[]){
		File inputFile = new File("input2.txt");
		Integer totalbuildings = 0;
		ArrayList<String> buildings = new ArrayList<String>();
		ArrayList<ArrayList<Integer>> pathtimes = new ArrayList<ArrayList<Integer>>();

		try{
			Scanner input = new Scanner(inputFile);
			while(input.hasNext()){
				totalbuildings++;
					String myline = input.nextLine();
					buildings.add(myline.split(" :")[0]);
					String nums = myline.split(": ")[1];
					String[] numbsplit = nums.split(" ");
					ArrayList<Integer> thetimes = new ArrayList<Integer>();
					for (String thisnum : numbsplit){
						thetimes.add(Integer.parseInt(thisnum));
					}
					pathtimes.add(thetimes);					
				}
		}catch(Exception e){
            System.out.println("Something went really wrong...");
        }   
		int[] firstpath = new int[totalbuildings-1];
		for(int i = 1; i < totalbuildings; i++){
			firstpath[i-1] = i;
		}		
		Building campus = Building.getInstance();
		
		campus.BuildingLoading(pathtimes, buildings, firstpath);
		
		MainHeap kickoff = new MainHeap(totalbuildings-1, firstpath);
		try{
			PrintWriter output = new PrintWriter(new FileWriter("output2.txt"));
			for(String paths : campus.returnBestBuildings()){
				output.println(paths);
			}
			output.close();
		}catch(Exception e){
            System.out.println("Something went really wrong...");
        }   
	}
}


