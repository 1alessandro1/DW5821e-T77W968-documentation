# Documentazione DW5821e - T77W968

(Ancora molto bozza)


Disclaimer: queste informazioni sono frutto del lavoro di diverse persone raccolte da varie fonti online, forum come 4pda.to, pazienza e tenacia nello sbatterci la testa sopra. 


# Come fare l'aggiornamento del firmware


Riferirsi a questo drive per avere tutte le versioni esistenti sul DW5821e:

I driver sul sito DELL vanno cercati sotto i laptop che montano questo modello, ossia:

- Latitude 5420 Rugged
- Latitude 5424 Rugged
- Latitude 7424 Rugged Extreme
- Precision 7540
- Precision 7740

Spesso capita che a seconda del modello del portatile che cercate la versione del firmware che appare sul sito varia dalle più vecchie (A03, A05) alle quasi nuove (A20) 

L'ultimo aggiornamento (ad oggi, 1 Marzo 2024) risulta essere quello di Settembre 2023 (driver ID `rx8nt` sul [sito Dell](https://www.dell.com/support/home/it-it/drivers/driversdetails?driverid=k8cr4
))

Se non avete un SMBIOS Dell, l'installer controllerà se siete in regola e fallirà. Per aggirare questo controllo, è sufficiente cambiare tramite registry editor eseguito come amministratore sulla vostra macchina la chiave "SystemManufacturer" sotto il percorso:

```

[HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS]

```

Impostandola come `"SystemManufacturer"="Dell Inc."`

<details>
    <summary>oppure per i pigri:</summary>
        Eseguire come amministratore questo file (salvandolo come dell.reg):

        
        Windows Registry Editor Version 5.00

        [HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS]
        "SystemManufacturer"="Dell Inc."  
</details>


# Come applicare le mod per le combo CA


Partendo da modem appena acquistato 

- Variante ESIM
- Variante non ESIM


# Come trasformare la variante ESIM nella variante non ESIM


# Comandi AT utili

- Informazioni generali: `AT^DEBUG?`
- Impostare l'APN: `AT+CGDCONT=1,"IPV4V6","wap.tim.it"`
- Controllo APN: `AT+CGDCONT?` (in lista troverete il vostro APN se l'avete impostato)
- Controllo combo CA: `AT^CA_INFO?` (da un risultato diverso da solo "OK" se sta aggregando)
- Cambio slot sim: `AT^SWITCH_SLOT?` (stato) - AT^SWITCH_SLOT=0 (slot 0) - AT^SWITCH_SLOT=1 (slot 1)
- Verifica di tutti i comandi disponibili: `AT+CLAC`
- Verificare IMEI
- Per modelli vergine, eseguire `at^nv=2497,1,"01"` + `AT+RESET` per disabilitare QTUNER ed evitare che sia bloccato in CFUN 5




# Cambiare IMEI

- Primo metodo:
  - Verificare tramite il comando: `AT^GETIMEI` il valore attuale dell'IMEI
  - Trovare l'IMEI valido che si vuole sostituire. In questo esempio, partiremo da un IMEI di un Google Pixel 4 XL, che ha come IMEI: `359220100402289`
  - Convertire l'imei sovrastante in formato GSM:
    - anteporre `80A` all'inizio della stringa dell'IMEI: `80A359220100402289`
    - dividere in coppie: `80,A3,59,22,01,00,40,22,89`
    - scambiare le cifre di ogni coppia: `08,3A,95,22,10,00,04,22,98`
    - Cancellare l'IMEI attuale: `AT^NV=550,0`
    - Verificare con `AT^GETIMEI` che il risultato sia `CME Error: memory failure`
    - Riscrivere il nuovo IMEI: `AT^NV=550,9,"08,3A,95,22,10,00,04,22,98"`
   

- Secondo metodo (universale):
  Avendo il backup `.xqcn` ottenuto tramite Qualcomm `QPST`, è possibile modificare l'imei partendo dall'originale presente in etichetta e andandolo a cercare con un CTRL + F dentro i contenuti dell'XML, assicurandosi prima di aver convertito la stringa di ricerca in formato GSM come suddetto.


# Effettuare il Cell Lock 

## Conversione: 
  
  1. Data la coppia EARFCN e PCI: (B7 wind: (`3350`)DEC - PCI specifico (`408`)DEC:
  
        1) Converti il PCI in esadecimale: PCI = (`408`)DEC -> (`01 98`)HEX`
        2) Inverti le coppie del PCI: (`01 98`)HEX => (`98,01`)HEX_swapped 

  2. Stessa operazione con l'EARFCN:

        1) Converti i EARFCN in esadecimale: EARFCN = (`1650`)DEC -> (`06 72`)HEX`
        2) Inverti le coppie dell'EARFCN: (`06 72`)HEX => (`72,06`)HEX_swapped


  3. Ora puoi applicare o solo `EARFCN lock` (lock di banda) o `EARFCN + PCI lock` (lock di banda + cella):

        1) Esempio del comando completo con lock banda + cella (EARFCN+PCI):

        ```
        at^efs="/nv/item_files/modem/lte/rrc/csp/pci_lock",4,"72,06,98,01"
        ```

        2) Eseguire un riavvio tramite il comando dopo la procedura:

        ```
        AT+RESET
        ```

        3) Per controllare che sia andata a buon fine, interrogando il file stesso:

        ```
        at^efs="/nv/item_files/modem/lte/rrc/csp/pci_lock"
        ```
        si dovrebbe ottenere:

          ^EFS: /nv/item_files/modem/lte/rrc/csp/pci_lock, 72,06,98,01
        

  4. Nel caso in cui si voglia effetturare **solo lock di banda** (solo EARFCN):

        1) Esempio del comando con solo lock di banda:

        ```
        at^efs="/nv/item_files/modem/lte/rrc/csp/earfcn_lock",2,"06,72"
        ```

        2) Eseguire un riavvio tramite il comando dopo la procedura:

        ```
        AT+RESET
        ```

        3) Per controllare che sia andata a buon fine, interrogando il file stesso:

        ```
        at^efs="/nv/item_files/modem/lte/rrc/csp/earfcn_lock"
        ```
        si dovrebbe ottenere:

          ^EFS: /nv/item_files/modem/lte/rrc/csp/pci_lock, 06,72


In sostanza con il primo scrivi un file di 4 byte in `/nv/item_files/modem/lte/rrc/csp/pci_lock` nel secondo scrivi un file di 2 byte in `/nv/item_files/modem/lte/rrc/csp/earfcn_lock`.

## Rimozione del cell lock (EARFCN+PCI)

```
at^efs="/nv/item_files/modem/lte/rrc/csp/pci_lock",0
```

Nel secondo caso

```
at^efs="/nv/item_files/modem/lte/rrc/csp/earfcn_lock",0
```

Ovviamente se la bts decide di cambiarti o di spegnere una banda, il modulo si disconnette da internet
