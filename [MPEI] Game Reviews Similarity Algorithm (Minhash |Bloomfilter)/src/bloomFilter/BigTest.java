package bloomFilter;

import java.text.DecimalFormat;
import java.util.Random;

public class BigTest {
	public static void main(String[] args) {
		Random gen = new Random();
		DecimalFormat df = new DecimalFormat("#.#####");
		int n = gen.nextInt(7000) + 2000;
		System.out.println("Inicio do BigTest para o BloomFilter");
		System.out.println("Numero de linhas aleatorias a inserir: " + n);
		BloomFilter filter = new BloomFilter(n);
		//Colocar valores de entrada / verificaçao nos bloomFilters
		String[] entrada = new String[n];
		String[] verificar = new String[n];
		for(int l=0;l<entrada.length;l++) {
			entrada[l] = RandomStringGen.getRandom(1000);
		}
		for(int r=0;r<entrada.length;r++) {
			verificar[r] = RandomStringGen.getRandom(1000);
		}
		double counter = 0;
		System.out.println("Inserindo no fitro:");
		for(int i=0;i<n;i++) {
			filter.insert(entrada[i]);
			if(i % 100 == 0) {
				System.out.print("*");
			}
		}
		System.out.println("\nConcluido com sucesso");
		System.out.println("-> Melhor numero de HashFunctions aplicadas (k): "+filter.bestK());
		System.out.println("-> Provabilidade de falsos positivos (Teorica) : " + df.format(filter.probFalsoPositivo()));
		System.out.println("-> Tamanho interno do vetor: " + n*8);
		for(int i=0;i<n;i++) {
			if(filter.isMember(verificar[i])) {
				counter++;
			}
		}
		double result = counter / n;
		System.out.println("Probabilidade real de falsos positivos no Bloom Filter: " + df.format(result));
		System.out.println("--------------------------------------------------------");
		System.out.println("Probabilidade real de falsos positivos utilizando diferentes k's :");
		BloomFilter filter2 = new BloomFilter(n, 2);
		counter = 0;
		for(int i=0;i<n;i++) {
			filter2.insert(entrada[i]);
		}
		for(int i=0;i<n;i++) {
			if(filter2.isMember(verificar[i])) {
				counter++;
			}
		}
		System.out.println("\nK->2,P->" + df.format(counter / n));
		BloomFilter filter6 = new BloomFilter(n, 6);
		counter = 0;
		for(int i=0;i<n;i++) {
			filter6.insert(entrada[i]);
		}
		for(int i=0;i<n;i++) {
			if(filter6.isMember(verificar[i])) {
				counter++;
			}
		}
		System.out.println("K->6,P->" + df.format(counter / n));
		BloomFilter filter9 = new BloomFilter(n, 9);
		counter = 0;
		for(int i=0;i<n;i++) {
			filter9.insert(entrada[i]);
		}
		for(int i=0;i<n;i++) {
			if(filter9.isMember(verificar[i])) {
				counter++;
			}
		}
		System.out.println("K->9,P->" + df.format(counter / n));
		BloomFilter filter20 = new BloomFilter(n, 20);
		counter = 0;
		for(int i=0;i<n;i++) {
			filter20.insert(entrada[i]);
		}
		for(int i=0;i<n;i++) {
			if(filter20.isMember(verificar[i])) {
				counter++;
			}
		}
		System.out.println("K->20,P->" + df.format(counter / n));
		System.out.println();
		System.out.println("------------------------------");
		
		int times[] = new int[5];
		for(int ti=0;ti<times.length;ti++) {
			times[ti] = gen.nextInt(550)+50;
		}
		
		System.out.print("Testar o contador do BloomFilter\nInserindo respetivamente");
		for(int time : times) {
			System.out.print(", "+time+"x");
		}
		System.out.println(", 5 Strings Diferentes\n");
		String[] randomStringsCount = new String[5];
		for(int q=0;q<randomStringsCount.length;q++) {
			randomStringsCount[q] = RandomStringGen.getRandom(4);
			System.out.println("String " + q + "->" + randomStringsCount[q]);
		}
		BloomFilter filterCount = new BloomFilter(n);
		for(int t=0;t<times.length;t++) {
			for(int k=0;k<times[t];k++) {
				filterCount.insert(randomStringsCount[t]);
			}
		}
		System.out.println("");
		for(int lp=0;lp<randomStringsCount.length;lp++) {
			System.out.println("Contagem da String " + lp + "->" + filterCount.getCount(randomStringsCount[lp]));
		}
		
	}
}
