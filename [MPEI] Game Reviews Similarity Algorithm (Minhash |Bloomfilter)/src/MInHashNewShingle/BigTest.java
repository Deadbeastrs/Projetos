package MInHashNewShingle;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Random;

import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.filechooser.FileSystemView;

public class BigTest {
	public static void main(String[] args) throws IOException {
		JFileChooser jfc = new JFileChooser(FileSystemView.getFileSystemView().getHomeDirectory());
		FileNameExtensionFilter xmlfilter = new FileNameExtensionFilter(
		     "csv files (*.csv)", "csv");
		jfc.setFileFilter(xmlfilter);
		int returnValue = jfc.showOpenDialog(null);
		File selectedFile = null;
		if (returnValue == JFileChooser.APPROVE_OPTION) {
			selectedFile = jfc.getSelectedFile();
		}else {
			 System.exit(0); 
		}
		DecimalFormat df = new DecimalFormat("#.#####");
		String nomeFich = selectedFile.getName();
		Path pa = Paths.get(nomeFich);
		Random gen = new Random();
		List<String> tudo = Files.readAllLines(pa, StandardCharsets.UTF_8);
		int[] rand = new int[10];
		for(int i=0;i<rand.length;i++) {
			rand[i] = gen.nextInt(tudo.size()-1);
		}
		NewMinHash minH = new NewMinHash(nomeFich);
		System.out.println("Teste ao MinHash:");
		System.out.println("Para este teste vamos comparar 10 reviews aleatórias do documento selecionado.");
		System.out.println("Strings a comprar:\n");
		for(int i=0;i<rand.length;i=i+2) {
			System.out.println(i+"- "+tudo.get(rand[i]).split(",")[2] + "  ->  " + (i+1)+"-"+tudo.get(rand[i+1]).split(",")[2]);
			System.out.println("Distancia exprimental (minHash): " + minH.getDistJacart(rand[i],rand[i+1],100));
			System.out.println("Distancia teorica (real): " + minH.realDistJacart(rand[i],rand[i+1]));
			System.out.println("----------------------------");
		}
		System.out.println();
		System.out.println("Erro médio para a totalidade do ficheiro aplicando MinHash (Erro no calculo da similaridade de 50000 Strings pelo MinHash)");
		double c = 0;
		for(int i=0;i<50000;i++) {
			c = c + Math.abs(minH.realDistJacart(i,i+1) - minH.getDistJacart(i,i+1,100));
			if(i % 5000 == 0) {
				System.out.print("*");
			}
		}
		System.out.println("\n" + df.format(c / (50000)*100) + "%");
	}
}
