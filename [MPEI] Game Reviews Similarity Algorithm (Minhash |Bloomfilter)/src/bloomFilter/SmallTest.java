package bloomFilter;

public class SmallTest {
	public static void main(String[] args) {
		int n = 11;
		System.out.println("Inicio do SmallTest para o BloomFilter");
		System.out.println("Numero de linhas aleatorias a inserir: " + n);
		BloomFilter filter = new BloomFilter(n);
		double counter = 0;
		System.out.println("Inserindo no fitro:");
		filter.insert("Portugal");
		filter.insert("Franca");
		filter.insert("Alemanha");
		filter.insert("Espanha");
		filter.insert("Italia");
		filter.insert("Japao");
		filter.insert("Japao");
		filter.insert("Japao");
		filter.insert("Japao");
		filter.insert("Japao");
		filter.insert("Alemanha");
		String[] array = {"Portugal","Franca","Alemanha","Espanha","Italia","Japao" };
		System.out.println("\nConcluido com sucesso");
		System.out.print("-> Strings inseridas no BloomFilter: ");
		System.out.print("{Portugal,Franca,Alemanha,,Alemanha,Espanha,Italia,Japao,Japao,Japao,Japao,Japao}\n");
		System.out.println("-> Melhor numero de HashFunctions aplicadas (k): "+filter.bestK());
		System.out.println("-> Provabilidade de falsos positivos: " + filter.probFalsoPositivo());
		System.out.println("-> Tamanho interno do vetor: " + n*8);
		for(int i=0;i<6;i++) {
			String line = array[i];
			if(!filter.isMember(line)) {
				counter++;
			}
		}
		
		System.out.println("-> Probabilidade de todos os paises inseridos pertencerem ao BloomFilter: " + (1-counter/n));
		System.out.println("-> Colisoes no BloomFilter : " + filter.colisoes());
		System.out.println("-> Numero de Vezes que as Strings aparecem no BloomFilter: ");
		System.out.println("Portugal: " + filter.getCount("Portugal"));
		System.out.println("Alemanha: " + filter.getCount("Alemanha"));
		System.out.println("Franca: " + filter.getCount("Franca"));
		System.out.println("Espanha: " + filter.getCount("Espanha"));
		System.out.println("Italia: " + filter.getCount("Italia"));
		System.out.println("Japao: " + filter.getCount("Japao"));

	}
}
