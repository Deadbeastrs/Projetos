package bloomFilter;

public class BloomFilter {
	private int[] vector;
	private double vecSize;
	private double dataSize;
	public int k;
	
	public BloomFilter(int size) {
		
		dataSize = size;
		vecSize = Math.round(( size * 8));
		vector = new int[(int)vecSize];
		this.k = bestK();
		
	}
	
	public BloomFilter(int size, int k) {
		
		dataSize = size;
		double p = 0.02;
		vecSize = Math.round(Math.abs((size * Math.log(p)) / Math.log(1 / Math.pow(2, Math.log(2)))));
		vector = new int[(int)vecSize];
		this.k = k;
		
	}
	
	public void insert(String s) {
		for(int i = 1; i <= k;i++) {
			int key = (int)( hash(s+i, i) % vecSize);
			vector[key] = vector[key]+1;
		}
	}
	
	public boolean isMember(String s) {
		boolean temp = true;
		for(int i = 1; i <= k;i++) {
			int key = (int)( hash(s+i, i) % vecSize);
			if(vector[key] == 0) {
				temp = false;
				break;
			}
		}
		return temp;
	}
	
	public double colisoes() {
        int sum = 0;
        for(int i =0;i<vector.length;i++) {
            if(vector[i] >0) {
                sum +=1;
            }
        }
                return (dataSize * bestK())-sum;
    }
	
	public int bestK() {
		return (int) Math.round((vecSize*Math.log(2)/dataSize));
	}
	
	public int getCount(String s) {
		if(isMember(s)) {
			int min = Integer.MAX_VALUE;
			for(int i = 1; i <= k;i++) {
				int key = (int)( hash(s+i, i) % vecSize);
				if(vector[key] < min) {
					min = vector[key];
				}
			}
			return min;
		}
		return 0;
	}
	
	public double probFalsoPositivo() {
		double ratio = dataSize / vecSize;
		return Math.pow((1-Math.exp(-1 * k * ratio)), k);
	}
	
	//HashFunction usada: djb2 feito por Dan Bernstein com algumas alterações para utilização neste trabalho
	public static int hash(String str, int k) {
        int hash = 0;
        for (int i = 0; i < str.length(); i++) {
            hash = (int) (str.charAt(i)*k + ((hash << 5) - hash * k));
        }
        return Math.abs(hash);
    }

}
