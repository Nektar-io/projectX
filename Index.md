INDEX
=====

Beskrivning
===========
Ett index över livskvalitet i boendet för en given adress. Arbetsnamn: "BoendeLivsKvalitetsIndex" (BLKI)

BLKI sätts samman av flera delindex som beskriver följande aspekter av en given adress:
1. Närmiljöindex
2. Restidsindex
3. Fritidsindex
4. Familjeindex
5. Andra index

Indexet beräknas som summan av [delindex * delindexvikt] där summan av delindexvikterna är lika med 1.

BLKI bör vara normaliserat för att gå från 0 till 100. Enklast är om alla delindex är normaliserade så att vi slipper ytterligare normalisering av totalindex.

Nedan följer en kort beskrivning av de olika delindex.


### 1 - Närmiljöindex
Beskrivning: Miljöfaktorer som t.ex. luftkvalitet, trafikbelastning, närhet till natur, tillgång till cykelbanor?

Vi har just nu: ???

**Beräkning och normalisering**

| Faktor | Normalisering | Vikt |
| ------ | ------------- | ---- |
| Avstånd till närmaste bibliotek (m) |  | 0.2 |
| Snittavstånd till tre närmaste museer (m) |  | 0.2 |
| Antal restauranger inom 500m omkrets  |  | 0.3 |
| Avstånd till närmaste badplats (m) |  | 0.1 |
| Snittavstånd till tre närmaste <br> idrottsanläggningar av valfritt slag (m) |  | 0.2 |


### 2 - Restidsindex
Beskrivning: Restider till centrala platser i Stockholm med SL, bil och ev. andra transportmedel.

Vi har just nu: Restider med SL:s reseplanerare, antal byten för en resa, gångtid till hållplats från adress, avstånd till parkeringsplatser

**Beräkning och normalisering**

| Faktor | Normalisering | Vikt |
| ------ | ------------- | ---- |
| Beräknad restid till T-Centralen | 100 - (tid/90)*100 | 0.8 |
| Avstånd till närmaste parkeringsplats (m) |  | 0.2 |



### 3 - Fritidsindex
Beskrivning: Närhet till kultur, shopping, mat och annat.

Vi har just nu: Närhet till museer och andra kulturinrättningar

**Beräkning och normalisering**

| Faktor | Normalisering | Vikt |
| ------ | ------------- | ---- |
| Avstånd till närmaste bibliotek (m) |  | 0.2 |
| Snittavstånd till tre närmaste museer (m) |  | 0.2 |
| Snittavstånd till fem närmaste restauranger (m) |  | 0.3 |
| Avstånd till närmaste badplats (m) |  | 0.1 |
| Snittavstånd till tre närmaste <br> idrottsanläggningar av valfritt slag (m) |  | 0.2 |



### 4 - Vardagsindex
Beskrivning: Faktorer som är viktiga för vardagslivet. Detta kan vara närhet till olika barn- och ungdomsfaciliteter (dagis, skolor, fritids) eller sjukvård (vårdcentraler/sjukhus), 

Vi har just nu: Närhet till skolor och dagis; kvalitetsnyckeltal för skolor; närhet till samlings- och festlokaler

**Beräkning och normalisering**

| Faktor | Normalisering | Vikt |
| ------ | ------------- | ---- |
| Avstånd till närmaste grundskola (m) |  | 0.15 |
| Avstånd till närmaste gymnasium (m) |  | 0.15 |
| Snittavstånd till tre närmaste dagis (m) |  | 0.15 |
| Avstånd till närmaste fritids (m) |  | 0.05 |
| Avstånd till närmaste fest- och möteslokal (m) |  | 0.05 |
| Avstånd till närmaste sjukhus (m) |  | 0.2 |
| Avstånd till närmaste vårdcentral (m) |  | 0.2 |


### 5 - Andra index
Övriga index som kan vara av intresse.
