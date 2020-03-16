package bloomFilter;

import java.security.SecureRandom;

public class RandomStringGen {
	//inspirado num algoritmo criado por mkyong
	private static final String CHAR_LOWER = "abcdefghijklmnopqrstuvwxyz";
	private static final String CHAR_UPPER = CHAR_LOWER.toUpperCase();
	private static final String NUMBER = "0123456789";
	private static final String DATA_FOR_RANDOM_STRING = CHAR_LOWER + CHAR_UPPER + NUMBER;
	private static SecureRandom random = new SecureRandom();
	public static String getRandom(int len) {
		 StringBuilder sb = new StringBuilder(len);
	        for (int i = 0; i < len; i++) {

				// 0-62 (exclusive), random returns 0-61
	            int rndCharAt = random.nextInt(DATA_FOR_RANDOM_STRING.length());
	            char rndChar = DATA_FOR_RANDOM_STRING.charAt(rndCharAt);
	            sb.append(rndChar);

	        }

	        return sb.toString();
	}
}
