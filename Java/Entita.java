public class Entita extends Thread {
    private Monitor m;
    private int id;
    private String tipo;

    public Entita(Monitor m, int id, String tipo) {
        this.m = m;
        this.id = id;
        this.tipo = tipo;
    }

    public int getID() {
        return this.id;
    }

    public String getTipo() {
        return this.tipo;
    }

    public void run() {

        try {
            // Sostituire il nome dei metodi con i metodi del monitor utilizzati.
            // NB FARE QUI TUTTE LE SLEEP NECESSARIE A SIMULARE LA DURATA DI UN'AZIONE.
            // NB2 sfruttare i getter di entita
            m.entra(this.getID(), this.getTipo());
            Thread.sleep(500); // Azione che simula la durata dell'entrata
            m.vota(this.getID(), this.getTipo());
            Thread.sleep(700); // Azione che simula la durata di voto
            m.esce(this.getID(), this.getTipo());
            Thread.sleep(200); // Azione che simula la durata dell'uscita

        } catch (
                InterruptedException e) {
            e.printStackTrace();
        }
    }
}

