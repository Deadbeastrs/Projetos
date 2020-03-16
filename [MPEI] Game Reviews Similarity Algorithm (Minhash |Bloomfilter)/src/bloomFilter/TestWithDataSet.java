package bloomFilter;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.DecimalFormat;
import java.util.Hashtable;
import java.util.List;
import java.util.Set;

import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.filechooser.FileSystemView;

public class TestWithDataSet {

	public static void main(String[] args) throws IOException {
		//Testar com o banco de dados que vamos usar na aplicacao conjunta
		DecimalFormat df = new DecimalFormat("#.#####");
		JFileChooser jfc = new JFileChooser(FileSystemView.getFileSystemView().getHomeDirectory());
		FileNameExtensionFilter xmlfilter = new FileNameExtensionFilter(
		     "csv files (*.csv)", "csv");
		jfc.setFileFilter(xmlfilter);
		int returnValue = jfc.showOpenDialog(null);
		if (returnValue == JFileChooser.APPROVE_OPTION) {
			File selectedFile = jfc.getSelectedFile();
			
			Path pa = selectedFile.toPath();
	        List<String> tudo = Files.readAllLines(pa, StandardCharsets.UTF_8);
	        Hashtable<String,Integer> scannerValues = new Hashtable<>();
	        
	        for(int i=1;i<tudo.size();i++) {
	            String[] temp0 = tudo.get(i).split(",");
	            if(scannerValues.containsKey(temp0[temp0.length-1])) {
	            	int x = scannerValues.get(temp0[temp0.length-1]) +1;
	            	scannerValues.put(temp0[temp0.length-1],x);
	            }
	            else {
	            	scannerValues.put(temp0[temp0.length-1],1);
	            }
	           
	            
	        }
	        BloomFilter b = new BloomFilter(scannerValues.size());
	        for(int i=1;i<tudo.size();i++) {
	            String[] temp0 = tudo.get(i).split(",");
	            b.insert(temp0[temp0.length-1]);  
	        }
	        double error = 0;
	        double numero = 0;
	        System.out.println("Fim do Test com valores do banco de dados usado na aplicacao conjunta para o BloomFilter");
	        System.out.println("-> Numero de reviews por jogo no banco de dados e no BloomFilter: \n");
	        Set<String> keys = scannerValues.keySet();
	        System.out.printf("%-50s %-40s%-10s%-10s%-10s%-10s%-10s %n","Jogos","   ","Ficheiro","","BloomFilter","","");
	        System.out.println("==========================================================================================================================================");
	        for (String s : keys) {
	           // System.out.println(s + " -> " + scannerValues.get(s) + "," + b.getCount(s) + " igualdade?: " + scannerValues.get(s).equals(b.getCount(s)));
	        	if(!scannerValues.get(s).equals(b.getCount(s))) {
	        		error++;
	        	}
	            numero++;
	        	System.out.printf("%-65s %-40s%-10s%-10s%-10s%-10s%-10s %n",s,"->",scannerValues.get(s),"|",b.getCount(s),"igualdade?: ",scannerValues.get(s).equals(b.getCount(s)));
	        }
	        System.out.println("----------------------------------------------------------------------------------------------------------------------------------------------------------");
	        System.out.printf("%-50s %-42s%-10s%-10s%-10s%-10s%-10s %n","Jogos","   ","Contagem Ficheiro","","Contagem BloomFilter","","");
	        System.out.println("----------------------------------------------------------------------------------------------------------------------------------------------------------");
	        System.out.println("Fim do Test com valores do banco de dados usado na aplicacao conjunta para o BloomFilter");
	        System.out.println("-> Numero de reviews por jogo no banco de dados e no BloomFilter: ");
	        System.out.println("==========================================================================================================================================");
	        System.out.println("Percentagem de erro: " + df.format((error/numero)*100) + "%");
		}
	}

}
