#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <ctype.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <unistd.h>

//----------Dichiarazione costanti-----------------

#define MAX_STRING_LENGTH 1000
#define MAX_FILE_NAME 255

//----------Dichiarazione funzioni-----------------

void print_usage (char *prog_name);
void father_handler (int signo);
//void figlio_handler (int signo); 

void codiceFiglioP1(char *nome_file, int altriParametriDaInserire);
void codiceFiglioP2(char *nome_file, int altriParametriDaInserire);

void wait_child();
//-----------Variabili Globali---------------------
int pipefd[2];
int pid1,pid2;
//-----------Prototipo di Main---------------------

int main(int argc, char **argv){
    int fdIn, fdOut; //fdOut da togliere se non ci sono file output
    char file_in[MAX_FILE_NAME], file_out[MAX_FILE_NAME];
    
    // Eventuale parametro numerico
    int t;
    
    // Controllo del numero di parametri
    if ( argc != 3 ) {
        fprintf(stderr, "Numero di parametri non valido\n");
        print_usage(argv[0]);
        exit(EXIT_FAILURE);
    }
    
    // Controllo se il primo argomento che ci si aspetta essere intero sia intero:
	for(int i = 0; i < strlen(argv[1]); i++){
        if( !isdigit(argv[1][i])){
	    	printf("Il secondo argomento non è un numero\n");
		    exit(1);
	    }    
    }
    t = atoi(argv[1]);

    // Copia dei nomi dei file input e output, passati per parametro
    strcpy(file_in, argv[1]);
    strcpy(file_out, argv[2]);

    // Apertura dei file input e output
    fdIn = open(file_in,O_RDWR);
    fdOut = open(file_out, O_CREAT | O_WRONLY, S_IRWXU);
    
    // Controllo dei file descriptor per vedere se l'apertura del file e' avvenuta correttamente
    if (fdIn == -1){
        fprintf(stderr,"Errore nell'apertura del file %s!",file_in);
        exit(EXIT_FAILURE); 
    }

    if (fdOut == -1){
        fprintf(stderr,"Errore nell'apertura del file %s!",file_out);
        exit(EXIT_FAILURE); 
    }
    
    // Creazione della pipe e controllo sulla creazione
    if (pipe (pipefd) < 0){
        perror("Errore nella creazione della pipe!");
        exit(-3);
    }

    // Prima fork e controllo dei pid
    pid1 = fork(); 
    if ( pid1 < 0 ) {
        perror("P0: Impossibile creare P1");
        exit(EXIT_FAILURE);

    }else if ( pid1 == 0 ){

        printf("P1, pid = %d\n",getpid());

        // Chiudere lato pipe che non si usa qui
        // close (pipefd...);
        
        // Azioni che svolge P1
        // signal(SIGUSR1, &p1_handler);
        codiceFiglioP1("inserire parametri qui");
        
    }else{
        // Processo padre più eventuali signal/fork per creare un secondo processo
        // signal(SIGALRM, &father_handler);
        // Creo P2, figlio di P0
        pid2=fork();

       // Controllo pid P2
        if ( pid2 < 0 ) {
        perror("P0: Impossibile creare P2");
        exit(EXIT_FAILURE);

        } else if ( pid2 == 0 ){

            printf("P2, pid = %d\n",getpid());
            // Chiudere lato pipe che non si usa qui
            // close (pipefd...);
        
            //azioni che svolge p2
            codiceFiglioP2(pid1, fdIn);
            
        } else {
            // Azioni del padre P0

            close(pipefd[0]); // chiusura del lato di lettura della pipe
            close(pipefd[1]); // chiusura del lato di scrittura della pipe
             
            // Uso alarm, in modo da inviare SIGALRM dopo t secondi di esecuzione dei processi
            // Se l'alarm viene lanciato, il father_handler manderà una SIG_KILL al processo padre
            alarm(t);  
            signal (SIGALRM, &father_handler);
            // Wait dei processi P1 e P2, in modo che il padre esegua certe azioni soltanto alla terminazione dei figli
            wait_child();
            wait_child();

            // Scrittura su file output, messaggio e chiusura del fd output
            write(fdOut, &counter, sizeof(int));
            fprintf(stdout, "Inserire messaggio da stampare");
            close(fdOut);
        }
    } 
    // Eventuale chiusura del fd Input
    close(fdIn);

    return 0;
}


void codiceFiglioP1(char *nome_file, int altriParametriDaInserire){
//-----------------------EXEC+Comandi----------------------    
    // Chiudo il canale stdout
    //close(1);
    //dup(pipefd[1]); //redirigo lo stdout nella pipe
    //execlp("sort", "sort", file_in, (char *) 0);
    //perror("Errore nella sort");
    //exit(EXIT_FAILURE);

    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // NB alcuni comandi pretendono che il file su cui si vogliono eseguire certe azioni
    // (ad esempio cat) sia aperto e non passato come parametro del comando.
    // Leggere attentamente il man!
//---------------------------------------------------------    
    
    //controllare il numero di caratteri all'interno di un file
    //dim = lseek(fdIn, 0, SEEK_END);
    // Dato che per determinare quanti caratteri compongono il file sono arrivato
    // con il puntatore a fine file, lo riposiziono a inizio file
    // lseek(fdIn, 0, SEEK_SET); 
    
    // NB OCCHIO A SEEK_CURL, SEEK_END, SEEK_SET!
//----------------------------------------------------------

    // Creare una stringa partendo da caratteri o numeri
    // 1) Creare un array di caratteri, e riempirlo volta per volta, \0 alla fine incluso
    // 2) usare sprintf:
    //    char stringa[20];
    //    int n;
    //    sprintf(stringa, "-f%d\0", n);
}

void codiceFiglioP2(char *nome_file, int altriParametriDaInserire){

}


void print_usage(char *prog_name){
    printf("Usage: %s\n", prog_name);
}

//---------------------Wait-------------------
void wait_child() {
    int pid_terminated, status;
    pid_terminated = wait(&status);
    
    if (pid_terminated < 0)    {
        fprintf(stderr, "P0: errore in wait. \n");
        exit(EXIT_FAILURE);
    }

    if(WIFEXITED(status)){
        printf("P0: terminazione volontaria del figlio %d con stato %d\n", pid_terminated, WEXITSTATUS(status));
        if (WEXITSTATUS(status) == EXIT_FAILURE){
            fprintf(stderr, "P0: errore nella terminazione del figlio pid_terminated\n");
            exit(EXIT_FAILURE);
        }

    }else if (WIFSIGNALED(status)){
        fprintf(stderr, "P0: terminazione involontaria del figlio %d a causa del segnale %d\n", pid_terminated,WTERMSIG(status));
        exit(EXIT_FAILURE);
    }
}

//-----------handler: gestione dei segnali-----------
void father_handler(int sgn) {
	if(sgn == SIGALRM) {
		printf("P0: tempo scaduto\n");
		kill(pid1, SIGKILL);
		// exit(6);
	}
	if(sgn == SIGUSR1 || sgn == SIGUSR2) {
		// Codice che gestisce questi due segnali
		printf("P0: ricevuto segnale SIGUSR1/2\n");
		
	}
}
/*void figlio_handler(int sgn){
    // Occhio che alcune variabili siano globali!
}*/
