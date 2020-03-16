package MInHashNewShingle;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class NewMinHash {

	private int dataSize;
	private FunctionGenerator gen;
	private List<String> tudo;
	
	public NewMinHash(String nomeFich) throws IOException {
		Path pa = Paths.get(nomeFich);
		tudo = Files.readAllLines(pa);
	}
	
	public int[][] getSignatureMatrix(int nOfHashFunc) throws IOException{
		HashSet<String> removeDup;
		gen = new FunctionGenerator(nOfHashFunc, 10003);
		dataSize = tudo.size();
		int[][] result = new int[dataSize][nOfHashFunc]; 
		for(int f=0;f<result.length;f++) {
			Arrays.fill(result[f], Integer.MAX_VALUE);
		}
		for(int p=0;p<tudo.size();p++) {
			if(p != 0) {
				String review = tudo.get(p).split(",")[2];  
				review = review.replaceAll("[^a-zA-Z0-9 -]","").toLowerCase();
				removeDup = new HashSet<>();
				while(review.length() < 5) {
					review = review+" ";
				}
				for(int i=0;i<review.length()-4;i++) {
					removeDup.add(review.substring(i, i+5)); 
				}
				result = createSignatureMatrix(result,nOfHashFunc,removeDup,p); 
			}
			if(p % 10000 == 1) {
				System.out.print("*");
			}
		}
		return result;
	}

	public int[][] createSignatureMatrix(int[][] result,int nOfHashFunc,Set<String> words, int p) throws IOException {
		for(String word : words) {
			for(int s=0;s<nOfHashFunc;s++) { 
				int hash = gen.calculateFunction(s,word);
				if(hash<result[p][s]) {
					result[p][s] = hash; 
				}
			}
		}
		return result;
	}

	public double getJacartDistance(int[][] result, int doc0,int doc1) {
		double counter0 = 0;
		double counter1 = 0;
		int[] compare0 = result[doc0];
		int[] compare1 = result[doc1];
		for(int i=0;i<compare0.length;i++) {
			if(compare0[i] == compare1[i]) {
				counter0 += 1;
			}
			counter1 +=1;
		}
		return counter0/counter1;
	}

	public double getDistJacart(int doc0, int doc1, int nOfHashFunc) throws IOException {
		HashSet<String> removeDup0;
		HashSet<String> removeDup1;
		gen = new FunctionGenerator(nOfHashFunc, 10003);
		String review0 = tudo.get(doc0).split(",")[2];  
		String review1 = tudo.get(doc1).split(",")[2];  
		review0 = review0.replaceAll("[^a-zA-Z0-9 -]","").toLowerCase();
		review1 = review1.replaceAll("[^a-zA-Z0-9 -]","").toLowerCase();
		removeDup0 = new HashSet<>();
		removeDup1 = new HashSet<>();
		while(review0.length() < 5) {
			review0 = review0+" ";
		}
		while(review1.length() < 5) {
			review1 = review1+" ";
		}
		for(int i=0;i<review0.length()-4;i++) {
			removeDup0.add(review0.substring(i, i+5)); 
		}
		for(int i=0;i<review1.length()-4;i++) {
			removeDup1.add(review1.substring(i, i+5)); 
		}
		int[][] result = new int[2][nOfHashFunc]; 
		for(int f=0;f<result.length;f++) {
			Arrays.fill(result[f], Integer.MAX_VALUE);
		}
		result = createSignatureMatrix(result,nOfHashFunc,removeDup0,0);
		result = createSignatureMatrix(result,nOfHashFunc,removeDup1,1);
		return getJacartDistance(result,0,1);

	}

	public double realDistJacart(int doc0, int doc1) throws IOException {
		HashSet<String> removeDup0;
		HashSet<String> removeDup1;
		String review0 = tudo.get(doc0).split(",")[2];  
		String review1 = tudo.get(doc1).split(",")[2];  
		review0 = review0.replaceAll("[^a-zA-Z0-9 -]","").toLowerCase();
		review1 = review1.replaceAll("[^a-zA-Z0-9 -]","").toLowerCase();
		removeDup0 = new HashSet<>();
		removeDup1 = new HashSet<>();
		while(review0.length() < 5) {
			review0 = review0+" ";
		}
		while(review1.length() < 5) {
			review1 = review1+" ";
		}
		for(int i=0;i<review0.length()-4;i++) {
			removeDup0.add(review0.substring(i, i+5)); 
		}
		for(int i=0;i<review1.length()-4;i++) {
			removeDup1.add(review1.substring(i, i+5)); 
		}
		HashSet<String> tempInters = new HashSet<>(removeDup0);
		HashSet<String> tempUnion = new HashSet<>(removeDup0);
		tempInters.retainAll(removeDup1);
		tempUnion.addAll(removeDup1);
		double intersection = Double.valueOf(tempInters.size());
		double reunion = Double.valueOf(tempUnion.size());
		double dist = intersection / reunion;
		return dist;
	}

}
