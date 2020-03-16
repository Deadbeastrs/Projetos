package aplicacaoConjunta;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;
import java.util.Scanner;
import java.util.Set;

import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.filechooser.FileSystemView;

import MInHashNewShingle.NewMinHash;
import bloomFilter.BloomFilter;

public class applicacao {
	private static List<String> tudo;
	private static NewMinHash min;
	private static int[][] result;
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
			System.out.println("Ficheiro ivalido");
			System.exit(0);
		}
			Path pa = selectedFile.toPath();
			DecimalFormat df = new DecimalFormat("#.#####");
			try {
			tudo = Files.readAllLines(pa, Charset.forName("UTF-8"));
			}catch(Exception e) {
				e.printStackTrace();
			}
	        HashSet<String> tabela = new HashSet<>();
	        for(int i=1;i<tudo.size();i++) {
	            String[] temp0 = tudo.get(i).split(",");
	            tabela.add(temp0[temp0.length-1]);
	        }
	        
	        BloomFilter b = new BloomFilter(tabela.size());
	        for(int i=1;i<tudo.size();i++) {
	            String[] temp1 = tudo.get(i).split(",");
	            b.insert(temp1[temp1.length-1]);
	        }
	        Scanner consoleScanner = new Scanner(System.in);
	        int input1 = 0;
	        
	        System.out.println("Selecione o valor de hashFunctions a utilizar no minHash (1<k<100)(recomendado k = 50):\n");
	        System.out.println("BigData - Tempo m�dio de espera para k=50 -> 55s");
	        System.out.println("MedData - Tempo m�dio de espera para k=50 -> 25s");
	        System.out.println("SmallData - Tempo m�dio de espera para k=50 -> 8s");
	        
	        try {
	        input1 = Integer.parseInt(consoleScanner.nextLine());
	        }catch(Exception e) {
	        	System.out.println("Valor Invalido");
	        	System.exit(0);
	        }
	        while(input1 > 100 || input1 <=0) {
	        	System.out.println("Valor tem que estar entre 1 e 100\nVolte a introduzir o valor:");
	        	try {
	    	        input1 = Integer.parseInt(consoleScanner.nextLine());
	    	        }catch(Exception e) {
	    	        	System.out.println("Valor Invalido");
	    	        	System.exit(0);
	    	    }
	        }
	        min = new NewMinHash(pa.getFileName().toString());
	        System.out.println("Criando Matriz de Assinaturas:");
	        result = min.getSignatureMatrix(input1);
	        System.out.println();
			System.out.println("M�todos Probabilisticos para Engenharia Inform�tica\nProjeto 8\nAplica��o Conjunta:");
			System.out.println("Menu:");
			System.out.println("0 -> Sair da Aplica��o;");
			System.out.println("1 -> Verificar se um jogo tem reviews");
			System.out.println("2 -> Mostrar o numero reviews de um jogo");
			System.out.println("3 -> Cole��o de reviews de um jogo (Sem reviews muito parecidas)");
			System.out.println("4 -> Percentagem de reviews iguais de 2 utilizadores");
			System.out.println("5 -> Percentagem por jogo de recomenda��es positivas");
			for(int i = 0;i<4;i++) {
				System.out.println();
			}
			System.out.print("Proximo comando: ");
			int input = consoleScanner.nextInt();
			consoleScanner.nextLine();
			System.out.println("");
			while(input != 0) {
				switch(input) {
				case 1:
					System.out.print("Nome do jogo : ");
                    String jogo = consoleScanner.nextLine();
                    System.out.print("tem reviews? = ");
                    System.out.println(b.isMember(jogo));
                    System.out.println("");
					break;
					
				case 2: 
                    System.out.print("Nome do jogo : ");
                    String jogo2 = consoleScanner.nextLine();
                    System.out.print("numero de reviews = ");
                    System.out.println(b.getCount(jogo2));
                    System.out.println("");
					break;
				
				case 3:
					System.out.print("Nome do jogo : ");
                    String jogo3 = consoleScanner.nextLine();
                    System.out.println();
                    System.out.println("Como o numero de reviews pode ser extenso, apenas vamos aprensentar na consola 5 exemplos, sendo todos os outros guardados num ficheiro com nome Reviews(NomeDoJogo).txt");
					criticas(jogo3);
                    break;
					
				case 4:
					System.out.println("Qual os ID's dos utilizadores que pretende comparar?");
					System.out.println("Utilizador 1-");
					String ut1 = consoleScanner.nextLine();
					System.out.println("Utilizador 2-");
					String ut2 = consoleScanner.nextLine();
					System.out.println("Percentagem de similaridade de reviews: " + (df.format(ban(ut1,ut2)*100))+"%");
					//172356913 - 244270722
					break;
				case 5:
					BloomFilter bloom = new BloomFilter(tudo.size());
                    Hashtable<String,Double> t = new Hashtable<>();

                    for(int i=1;i<tudo.size();i++) {
                        String[] temp0 = tudo.get(i).split(",");
                        if(temp0[1].equals("Recommended")) {
                            bloom.insert(temp0[3]);
                        }
                        if(t.containsKey(temp0[3])) {
                            t.put(temp0[3],t.get(temp0[3]) +1);
                        }
                        else {
                            t.put(temp0[3],1.0);
                        }

                    }
                    PrintWriter writer = new PrintWriter("ReviewsPercentagem.txt", "UTF-8");
                    writer.println("Percentagem de Review Positivas dos jogos:\n");
                    System.out.println("Como o numero de jogos pode ser extenso, apenas vamos aprensentar na consola 5 exemplos, sendo todos os outros guardados num ficheiro com nome ReviewsPercentagem.txt");
                    System.out.println();
                    Set<String> keys = t.keySet();
                    for(String key: keys){
                        t.put(key,(bloom.getCount(key)/t.get(key))*100);
                    }
                    Iterator<Entry<String, Double>> iter = t.entrySet().iterator();
                    int c = 0;
                    while(iter.hasNext()) {
                    	if(c < 5) {
                    		System.out.println(iter.next() + "%");
                    	}
                    	c++;
                        writer.write(iter.next() + "%"+"\n");
                    }
                    writer.close();
					break;
					
				default:
					System.out.println("comando invalido");
					System.out.println("");
					break;
				}
				
				System.out.print("\nProximo comando: ");
				input = consoleScanner.nextInt();
				System.out.println("");
				consoleScanner.nextLine();
			}
			consoleScanner.close();
		}
	
		private static double ban(String ut0, String ut1) throws IOException {
			List<Integer> ut0List = new ArrayList<>();
			List<Integer> ut1List = new ArrayList<>();
			for(int i=1;i<tudo.size();i++) {
				String[] info = tudo.get(i).split(",");
				if(info[0].equals(ut0)) {
					ut0List.add(i);
				}
				if(info[0].equals(ut1)) {
					ut1List.add(i);
				}
			}
			System.out.println("\nQuantidade de reviews de " + ut0 + ": " + ut0List.size());
			System.out.println("Quantidade de reviews de " + ut1 + ": " + ut1List.size()+"\n");
			Set<String> reun = new HashSet<>();
			double counterSame = 0;
			for(int i=0;i<ut0List.size();i++) {
				for(int p=0;p<ut1List.size();p++) {
					if(min.getJacartDistance(result, ut0List.get(i), ut1List.get(p)) > 0.8) {
						counterSame++;
						ut0List.remove(i);
						ut1List.remove(p);
					}else {
						reun.add(tudo.get(ut0List.get(i)));
						reun.add(tudo.get(ut1List.get(p)));
					}
				}
			}
			return counterSame / reun.size();
		}

		private static void criticas(String nomeJogo) throws IOException {
			PrintWriter writer;
			List<Integer> gameReviews = new ArrayList<>();
			for(int i=1;i<tudo.size();i++) {
				String[] info = tudo.get(i).split(",");
				if(info[3].equals(nomeJogo)) {
					gameReviews.add(i);
				}
			}
			long count = 0;
			int countPrev = gameReviews.size();
			System.out.println();
			for(int p=0;p<gameReviews.size();p++) {
				for(int s=p+1;s<gameReviews.size();s++) {
					if(min.getJacartDistance(result,gameReviews.get(p), gameReviews.get(s)) > 0.8) {
						gameReviews.remove(gameReviews.get(s));
					}
					count++;
				}
				if(p % 5000 == 0) {
					System.out.print("*");
				}
			}
			System.out.println();
			for(int i=0;i<5;i++) {
				if(gameReviews.size() > i) {
					System.out.println("Review "+i+"-> "+tudo.get(gameReviews.get(i)).split(",")[2]);
					System.out.println();
				}
			}
			System.out.println("Numero de reviews similares detectado: " + (countPrev - gameReviews.size()));
			System.out.println("Compara��es efetuadas: " + count);
			writer = new PrintWriter("Reviews"+ nomeJogo +".txt", "UTF-8");
			writer.println("Reviews do jogo " + nomeJogo + ":\n");
			writer.println("Utilizador - Review\n");
			for(int q=0;q<gameReviews.size();q++) {
				String review = tudo.get(gameReviews.get(q)).split(",")[2];
				String utilizador = tudo.get(gameReviews.get(q)).split(",")[0];
				writer.println(utilizador+"-" + review+"\n");
			}
			writer.close();
		}
		
	}
