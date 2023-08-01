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

L'ultimo aggiornamento (ad oggi, 1 Agosto 2023) risulta essere quello di settembre 2022 (driver ID `k8cr4` sul sito Dell)

https://www.dell.com/support/home/it-it/drivers/driversdetails?driverid=k8cr4



Se non avete un SMBIOS Dell, l'installer controllerà se siete in regola e fallirà. Per aggirare questo controllo, è sufficiente cambiare tramite registry editor eseguito come amministratore sulla vostra macchina la chiave "SystemManufacturer" sotto il percorso:


[HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS]


Impostandola come "SystemManufacturer"="Dell Inc."

Oppure per i pigri eseguire come amministratore questo file (dell.reg)


# Come applicare le mod per le combo CA


Partendo da modem appena acquistato 

- Variante ESIM
- Variante non ESIM


# Come trasformare la variante ESIM nella variante non ESIM


# Comandi AT utili

- Informazioni generali: AT^DEBUG?
- Impostare l'APN: AT+CGDCONT=1,"IPV4V6","wap.tim.it"
- Controllo APN: AT+CGDCONT? (in lista troverete il vostro APN se l'avete impostato)
- Controllo combo CA: AT^CA_INFO? (da un risultato diverso da solo "OK" se sta aggregando)
- Cambio slot sim: AT^SWITCH_SLOT? (stato) - AT^SWITCH_SLOT=0 (slot 0) - AT^SWITCH_SLOT=1 (slot 1)
- Verifica di tutti i comandi disponibili: AT+CLAC
- Verificare IMEI
- at^nv=2497,1,"01" + AT+RESET per disabilitare QTUNER ed evitare che sia bloccato in CFUN 5




# Cambiare IMEI

2 modi

Tramite QPST, modificando manualmente l'imei dell'XML

Tramite procedura documentata su 4PDA





