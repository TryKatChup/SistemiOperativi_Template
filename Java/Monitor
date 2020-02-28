import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Monitor {

    //----------------------------Costanti-------------------------------

    private final int MAX = 100; // Limite

    private final int D0 = 0; // Definisco delle costanti che indicano il verso di percorrenza: d1 e' opposto a d0
    private final int D1 = 1;

    //--------Definisco costanti relative al tipo di Entita---------------
    private final String ST = "ST"; // Definisco delle costanti che indicano il tipo di elettore
    private final String TA = "TA";
    private final String PR = "PR";
    
    
    private int count = 0; //contatore
    private Lock lock = new ReentrantLock();

    //----------------------------Condition-------------------------------

    private Condition nC1 = lock.newCondition();
    private Condition nC2 = lock.newCondition();
    private Condition nC3 = lock.newCondition();
    private Condition nC4 = lock.newCondition();
    
    //--------------------Condition in più direzioni(3 direzioni) e 2 azioni (matrice 3x2)-----------------
    // Ho utlizzato un array bidimensionale: il primo indice esprime una stazione, mentre il secondo indice indica l'operazione che si vuole effettuare (acquisizione o restituzione)
    //private Condition sin[][] = new Condition[3][2];
    //private Condition cop[][] = new Condition[3][2];

    

    //----------------------------Boolean----------------------------------

    private boolean b1 = false;
    private boolean b2 = false;
    private boolean b3 = false;

    private int[] sospC1 = new int[2]; // Ho utlizzato un array: la lunghezza dell'array è dovuta al numero di direzioni possibili (avanti o indietro)
    // Mentre il valore di ciascuna casella dell'array rappresenta il numero di entita' in attesa

    private int[] sospC2 = new int[2];
    private int[] sospC3 = new int[2];


    private int[] e1 = new int[2];

    //-----------------------Sospensioni in più direzioni(3 direzioni) e 2 azioni (matrice 3x2)---------------------
    //private int[][] sospSin = new int[3][2];
    //private int[][] sospCop = new int[3][2];

    /*public Monitor() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 2; j++) {
                sin[i][j] = lock.newCondition();
                cop[i][j] = lock.newCondition();

            }
        }
    }*/
    public void nomeAzione1(int id, int dir, String tipo)// metodo entry:
            throws InterruptedException {
        lock.lock();
        System.out.println("Il tal processo " + id + " vuole essere avviato in direzione " + dir);
        try {
            if (dir == D0 && tipo.equals(ST) { // Controllo la direzione D0 e il tipo di variabile
                while ("Varie condizioni non banali da inserire per cui il processo passa in wait (Occhio alle priorità)") {
                    sospC1[D0]++;
                    nC1.await();
                    sospC1[D0]--;

                }
                // Azioni da eseguire fuori dal while se non c'è più attesa


                System.out.println("Il processo" + id + " ha finito il suo dovere in direzione " + dir);
            } else if (dir == D1) {
                while ("Azioni che tengono conto della direzione D1") {
                    sospC1[D1]++;
                    nC1.await();
                    sospC1[D1]--;
                }
                // Azioni da eseguire fuori dal while se non c'è più attesa
                System.out.println("Il bus " + id + " ha finito di percorrere il ponte in direzione " + dir);
            }
            // Inserire altre condizioni



//------------------------------------signalAll----------------------------
//NB Le signal non vanno sempre utilizzate in tutti i metodi del monitor. Se si usano le signal assicurarsi che ci sia prima di esse una lock.lock() e dopo di esse una lock.unlock()

            if (sospC1[D1] > 0 || sospC1[D0] > 0)
                nC1.signalAll();
            else if (sospC2[D1] > 0 || sospC2[D0] > 0)
                nC2.signalAll();

            else if (sospC3[D0] > 0 || sospC3[D1] > 0)
                nC3.signalAll();

        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
    }
}
