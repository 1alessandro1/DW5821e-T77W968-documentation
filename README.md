# Documentazione DW5821e - T77W968

(Ancora molto bozza)

**DISCLAIMER: queste informazioni sono frutto del lavoro di diverse persone raccolte da varie fonti online, forum come 4pda.to, pazienza e tenacia nello sbatterci la testa sopra.**


# Come fare l'aggiornamento del firmware

Riferirsi a [questo drive](https://www.mbhomeserver.it/s/Gk2zRwtw9FB6Y7m?path=%2FModem+%5BMiniPCIE+-+M.2+key+B+NGFF%5D%2FDell%2FDW5821e+%28MDM9660%2C+Snapdragon+X20%29) per avere tutte le versioni esistenti sul DW5821e 

# Effettuare l'installazione dei driver 

**Prerequisito**: portatile DELL, o **aver cambiato l'SMBIOS in registry editor** oppure **seguito il file** `dell.reg` (leggi sotto) 

Qualora non avete un SMBIOS Dell, l'installer ufficiale controllerà se siete in regola e fallirà. Per aggirare questo controllo, è sufficiente cambiare tramite registry editor eseguito come amministratore sulla vostra macchina la chiave *SystemManufacturer* al percorso:

```
[HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS]
```

Impostandola manualmente al valore `Dell Inc.` e premendo enter.


<details>
    <summary>oppure per i pigri:</summary>
        Eseguire come amministratore questo file (salvandolo come dell.reg):

        
        Windows Registry Editor Version 5.00

        [HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS]
        "SystemManufacturer"="Dell Inc."  
</details>

Installare il driver è necessario non solo per poter comunicare col modem via MBIM (avere quindi connettività come fosse una chiavetta) ma anche per avere le porte seriali (DIAG+AT+GNSS) disponibili in Device manager. In [questa](https://www.mbhomeserver.it/s/Gk2zRwtw9FB6Y7m?path=%2FModem+%5BMiniPCIE+-+M.2+key+B+NGFF%5D%2FDell%2FDW5821e+%28MDM9660%2C+Snapdragon+X20%29%2F2_Dell+Installers+-+EXE%2FFirmware
) cartella, sono state collezionate nel tempo tutte le versioni che sono state messe a mano a mano disponibili. Se volete scaricare da sorgenti ufficiali, l'ultimo aggiornamento (ad oggi, 1 Marzo 2024) risulta essere quello di Settembre 2023, driver ID `rx8nt` sul [sito Dell](https://www.dell.com/support/home/it-it/drivers/driversdetails?driverid=k8cr4
)


# Come applicare le mod per le combo CA

Aprire [QPST](https://www.mbhomeserver.it/s/Gk2zRwtw9FB6Y7m/download?path=%2FTools%20Qualcomm&files=QPST_2.7.496.zip), dirigersi nel percorso `/nv/item_files/rfnv` e sostituire il file `00028874` con quello che trovate [qui](https://github.com/1alessandro1/Combo-00028874-DW5821e/releases/download/v3/00028874_v3_Zefiro_4ca_28) avendo cura di rinominarlo in `00028874` preventivamente all'operazione. Basta effettuare un tasto destro sul file originale, selezionare `Copy data file FROM PC` e puntare al file appena scaricato, così facendo verrà sovrascritto.

Rimuovere inoltre il file al percorso `/policyman/carrier_policy.xml`

# Come trasformare la variante ESIM nella variante non ESIM

- Variante ESIM:

   1° modo: mandarlo in fastboot con `AT^FASTBOOT` oppure se avete già attivato ADB, `adb reboot-bootloader` e `fastboot erase efs2` vi restorerà i contenuti della EFS presenti in `foxnv` che conterrà la EFS di un Non-ESIM 

  2° modo: effettuare il restore di un backup xqcn di un modulo non ESIM (lo trovate in questo repository)
  
- Variante non ESIM: tramite il restore dell'xqcn della variante ESIM, (presente in questo repository) è possibile farlo tornare in modalità ESIM.

Riferirsi alla cartella contenente i file `xqcn` corretti per effettuare quanto vi serve.

# Comandi AT utili

- Informazioni generali: `AT^DEBUG?`
- Impostare l'APN: `AT+CGDCONT=1,"IPV4V6","wap.tim.it"`
- Controllo APN: `AT+CGDCONT?` (in lista troverete il vostro APN se l'avete impostato)
- Controllo combo CA: `AT^CA_INFO?` (da un risultato diverso da solo "OK" se sta aggregando)
- Verifica di tutti i comandi disponibili: `AT+CLAC`
- Verificare IMEI: `AT^GETIMEI`
- Per modelli vergine, eseguire `at^nv=2497,1,"01"` + `AT+RESET` per disabilitare QTUNER ed evitare che sia bloccato in CFUN 5


<details>
    <summary>Altri comandi da copia-incollare su luci-app-atcommands</summary>
    
    Signal Quality ➜ AT+CSQ?;AT+CSQ?
    Debug Information/Cell Information ➜ AT^DEBUG?;AT^DEBUG?
    General System Firmware Information and IMEI ➜ ATI;ATI
    Check Detailed Firmware Version ➜ AT^VERSION?;AT^VERSION?
    Check Customer Mode ➜ AT^CUSTOMER?;AT^CUSTOMER?
    Carrier Aggregation Info ➜ AT^CA_INFO?;AT^CA_INFO?
    Check Enabled Bands ➜ AT^BAND_PREF_EXT?;AT^BAND_PREF_EXT?
    
    Check RAT Mode Preferences ➜ AT+COPS?;AT+COPS?
    Check SLMODE set ➜ AT^SLMODE?;AT^SLMODE?
    Set WCDMA only RAT (non permanent across reboots) ➜ AT^SLMODE=0,14;AT^SLMODE=0,14
    Set LTE only RAT (non permanent across reboots) ➜ AT^SLMODE=0,30;AT^SLMODE=0,30
    Set WCDMA only RAT (permanent across reboots) ➜ AT^SLMODE=1,14;AT^SLMODE=1,14
    Set LTE only RAT (permanent across reboots) ➜ AT^SLMODE=1,30;AT^SLMODE=1,30
    Set WCDMA And LTE Only ➜ AT^SLMODE=1,35;AT^SLMODE=1,35
    Revert preference mode to auto ➜ AT^SLMODE=1,4;AT^SLMODE=1,4
    
    
    Enable LTE B3 only ➜ AT^BAND_PREF_EXT=LTE,2,3;AT^BAND_PREF_EXT=LTE,2,3
    Enable LTE Bands 1+3+7+20 ➜ AT^BAND_PREF_EXT=LTE,2,1:3:7:20;AT^BAND_PREF_EXT=LTE,2,1:3:7:20
    Enable LTE Bands 1+3+7+38 ➜ AT^BAND_PREF_EXT=LTE,2,1:3:7:38;AT^BAND_PREF_EXT=LTE,2,1:3:7:38
    Disable LTE Bands 20 and 28 ➜ AT^BAND_PREF_EXT=LTE,1,20:28
    
    Display Neighbour Cell RSRP Info ➜ AT+VZWRSRP?;AT+VZWRSRP?
    Display Neighbour Cell RSRQ Info ➜ AT+VZWRSRQ?;AT+VZWRSRQ?
    Check APN Configuration ➜ AT+CGDCONT?;AT+CGDCONT?
    Check APN Configuration ➜ AT+VZWAPNE?;AT+VZWAPNE?
    Check Modem Temperature ➜ AT^TEMP?;AT^TEMP?
    
    Restore Default Bands ➜ AT^BAND_PREF_EXT;AT^BAND_PREF_EXT
    Reboot Modem ➜ AT+RESET;AT+RESET
</details>



# Cambiare IMEI

## Primo metodo:
  - Verificare tramite il comando: `AT^GETIMEI` il valore attuale dell'IMEI
  - Trovare l'IMEI valido che si vuole sostituire. In questo esempio, partiremo da un IMEI di un Google Pixel 4 XL, che ha come IMEI: `359220100402289`
  - Convertire l'imei sovrastante in formato GSM:
    - anteporre `80A` all'inizio della stringa dell'IMEI: `80A359220100402289`
    - dividere in coppie: `80,A3,59,22,01,00,40,22,89`
    - scambiare le cifre di ogni coppia: `08,3A,95,22,10,00,04,22,98`
    - Cancellare l'IMEI attuale: `AT^NV=550,0`
    - Verificare con `AT^GETIMEI` che il risultato sia `CME Error: memory failure`
    - Riscrivere il nuovo IMEI: `AT^NV=550,9,"08,3A,95,22,10,00,04,22,98"`
   

## Secondo metodo (universale):
  Avendo il backup `.xqcn` ottenuto tramite Qualcomm `QPST`, è possibile modificare l'imei partendo dall'originale presente in etichetta e andandolo a cercare con un CTRL + F dentro i contenuti dell'XML, assicurandosi prima di aver convertito la stringa di ricerca in formato GSM come suddetto.


# Effettuare il Cell Lock 

In sostanza con il primo scrivi un file di 4 byte in `/nv/item_files/modem/lte/rrc/csp/pci_lock` nel secondo scrivi un file di 2 byte in `/nv/item_files/modem/lte/rrc/csp/earfcn_lock`.

## In termini operativi 
  
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


## Rimozione del cell lock (EARFCN+PCI)

```
at^efs="/nv/item_files/modem/lte/rrc/csp/pci_lock",0
```

Nel secondo caso

```
at^efs="/nv/item_files/modem/lte/rrc/csp/earfcn_lock",0
```

Ovviamente se la bts decide di cambiarti o di spegnere una banda, il modulo si disconnette da internet



# Recovery via EDL

Per ora, riferirsi a [questo documento](https://www.mbhomeserver.it/s/Gk2zRwtw9FB6Y7m?path=%2FModem%20%5BMiniPCIE%20-%20M.2%20key%20B%20NGFF%5D%2FDell%2FDW5821e%20(MDM9660%2C%20Snapdragon%20X20)%2F4_Debrick-EDL-fastboot&openfile=21330) per recuperare il modulo qualora non spunti come vivo in alcun sistema operativo, assicurandosi di non flashare una versione più vecchia di quella attualmente presente. Se siete su una revision recente, come documentato in [questo](https://github.com/1alessandro1/DW5821e-T77W968-documentation/blob/main/Dell-Installers-Links.md) documento, usare [questo zip](https://www.mbhomeserver.it/s/Gk2zRwtw9FB6Y7m/download?path=%2FModem%20%5BMiniPCIE%20-%20M.2%20key%20B%20NGFF%5D%2FDell%2FDW5821e%20(MDM9660%2C%20Snapdragon%20X20)%2F4_Debrick-EDL-fastboot&files=T77W968_recovery_emergency_REV_050_delldownloadusbdrivers-inf.zip)) con il programmer apposito e il file `contents.xml` da puntare in QPST nell'applicativo `Software download > SB 3.0`. Io in passato ho flashato una revision più vecchia (REV 035) impossibilitando ogni rientro in `9008` prolungato e vi dico che è stato molto spiacevole, perché l'unico modo per recuperare il modulo in questo stato in cui rimane in `9008` per meno di 10 secondi è flashare solo `aboot` (e `mibib`) - non fare caso allo screenshot in cui compare `boot` che può essere flashato in seguito via `fastboot`.

![image](https://github.com/1alessandro1/DW5821e-T77W968-documentation/assets/46293832/e31b36ce-9092-4524-be03-8ee10f82a0ee)




