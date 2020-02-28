import java.util.Random;

public class Main extends Thread {
    public static void main(String[] args) {
        final int N = 3; // max value da impostare
        Monitor m = new Monitor();
        Votante[] v = new Votante[N * 2];

        // Aggiungere ovviamente anche le altre entita coinvolte
        Random ran = new Random();
        for (int i = 0; i < N * 2; i++) {
        // Cambiare 3 con il numero di tipi di Entita
        // Il tipo di Entita è una stringa
            if (ran.nextInt(3) == 0) {
                v[i] = new Entita(m, i, "ST");
            } else if (ran.nextInt(3) == 1) {
                v[i] = new Entita(m, i, "TA");
            } else {
                v[i] = new Entita(m, i, "PR");
            }

            v[i].start();

        }

    }
}
