package MInHashNewShingle;

import java.io.IOException;
import java.util.HashMap;
import java.util.Random;

public class FunctionGenerator {
	
	HashMap<String,Integer> words;
	private int nOfFunc;
	private int[] a;
	private int[] b;
	private long c;
	
	public FunctionGenerator(int nOfFunc, int max) {
		this.nOfFunc = nOfFunc;
		this.c = max;
		a = new int[nOfFunc];
		b = new int[nOfFunc];
		getRandomFunction(max);
	}
	
	private void getRandomFunction(int max) {
		Random random = new Random();
		for(int i=0;i<nOfFunc;i++) {
			a[i] = random.nextInt(max) + 1;
			b[i] = random.nextInt(max) + 1;
		}
	}
	
	public int calculateFunction(int indexOfFunc, String word) throws IOException {
		return (int) (Math.abs((a[indexOfFunc])*word.hashCode()+b[indexOfFunc]) % c);
	}
}
