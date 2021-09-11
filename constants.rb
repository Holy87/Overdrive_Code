#Questo modulo cambia gli equilibri di gioco
module CPanel
  #Modifica dei parametri
  TSWRate = 0.7 #moltiplicatore danno con due spade
  TWHIT = 3 #riduzione hit con due spade
  CHARGEDOMATTACK = 1 #carica della dominazione quando viene attaccata
  MPDIVISOR = 5 #divisore del danno HP in MP
  PROTECTRATE = 0.75 # moltiplicatore danno ad alleato se uno ha altruismo
  SAVE_VERSION = 4.0 # versione del salvataggio
  MAX_STORY = 57 #fine della storia per la variabile 72
  # Aggiusta il rate di guadagno nei combattimenti
  EXPRATE = 95 #rateo esperienza
  APDRATE = 100 #rateo PA
  GOLDRATE = 100 #rateo oro
end

Font.default_name = ["VL PGothic","Verdana","Arial", "Courier New"]
Font.default_size = 23

module Stati #stati negativi da copiare sul nemico
  Negativi = [2,3,4,5,6,77,78,13,14,15,16,28,78,79,80,87,93,94,95,112,113,115,130,
              131,132,133,134,135,136,137,287,288,289]
end