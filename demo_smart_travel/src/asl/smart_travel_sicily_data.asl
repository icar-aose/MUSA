// SICILY: LOCAL TRASPORTATION
distance(palermo,trapani,110).
distance(palermo,messina,223).
distance(palermo,cefalu,57).
distance(palermo,aragona,114).
distance(palermo,roccapalumba,223).
distance(palermo,agrigento,127).
distance(palermo,catania,208).
distance(palermo,siracusa,258).

distance(messina,catania,95).
distance(messina,cefalu,166).

distance(catania,siracusa,67).
distance(catania,agrigento,162).
distance(catania,roccapalumba,174).
distance(catania,taormina,53).

distance(agrigento,catania,160).
distance(agrigento,roccapalumba,73).
distance(agrigento,palermo,128).

distance(siracusa,noto,38).

distance(aragona,catania,159).
distance(A,B,KM) :- distance(B,A,KM).
distance(A,B,0).


// train

/* From Palermo */
train(palermo,trapani,time(6,37,00),time(13,52,00),10.4).
train(palermo,trapani,time(10,39,00),time(14,25,00),8).
train(palermo,trapani,time(14,39,00),time(18,25,00),10.4).
train(palermo,trapani,time(18,09,00),time(21,12,00),8).
train(palermo,trapani,time(18,09,00),time(21,54,00),10.4).

train(palermo,messina,time(6,8,00),time(9,3,00),11.80).
train(palermo,messina,time(8,8,00),time(11,4,00),11.80).
train(palermo,messina,time(10,5,00),time(12,55,00),19).
train(palermo,messina,time(11,8,00),time(14,45,00),11.80).
train(palermo,messina,time(14,5,00),time(17,20,00),11.80).
train(palermo,messina,time(15,8,00),time(18,30,00),11.80).
train(palermo,messina,time(17,8,00),time(20,48,00),11.80).

train(palermo,cefalu,time(6,8,00),time(6,55,00),5.15).
train(palermo,cefalu,time(7,0,00),time(7,54,00),8).
train(palermo,cefalu,time(7,8,00),time(8,04,00),5.15).
train(palermo,cefalu,time(8,8,00),time(8,51,00),5.15).
train(palermo,cefalu,time(9,3,00),time(10,2,00),5.15).
train(palermo,cefalu,time(10,5,00),time(10,53,00),8).
train(palermo,cefalu,time(11,8,00),time(12,5,00),5.15).
train(palermo,cefalu,time(12,5,00),time(12,57,00),5.15).
train(palermo,cefalu,time(13,8,00),time(14,0,00),5.15).
train(palermo,cefalu,time(14,5,00),time(15,1,00),5.15).

train(palermo,aragona,time(7,49,00),time(9,33,00),8).
train(palermo,roccapalumba,time(15,49,00),time(16,41,00),5.15).

train(palermo,agrigento,time(7,49,00),time(9,52,00),8.30).
train(palermo,agrigento,time(8,49,00),time(10,52,00),8.30).
train(palermo,agrigento,time(11,49,00),time(13,52,00),8.30).
train(palermo,agrigento,time(13,49,00),time(15,52,00),8.30).
train(palermo,agrigento,time(14,49,00),time(16,52,00),8.30).
train(palermo,agrigento,time(15,49,00),time(17,52,00),8.30).
train(palermo,agrigento,time(16,49,00),time(18,52,00),8.30).
train(palermo,agrigento,time(16,49,00),time(18,52,00),8.30).
train(palermo,agrigento,time(17,49,00),time(19,52,00),8.30).
train(palermo,agrigento,time(18,47,00),time(21,4,00),8.30).
train(palermo,agrigento,time(20,22,00),time(22,30,00),8.30).



/* From Messina */
train(messina,catania,time(6,38,00),time(11,08,00),7).
train(messina,catania,time(12,18,00),time(14,06,00),7).
train(messina,catania,time(13,20,00),time(14,54,00),7).
train(messina,catania,time(15,55,00),time(17,19,00),7).
train(messina,catania,time(17,50,00),time(19,32,00),7).
train(messina,catania,time(18,40,00),time(20,11,00),7).
train(messina,catania,time(21,45,00),time(23,07,00),7).

train(messina,cefalu,time(6,41,00),time(10,7,00),9.1).
train(messina,cefalu,time(11,25,00),time(13,51,00),9.1).
train(messina,cefalu,time(12,30,00),time(15,04,00),9.1).
train(messina,cefalu,time(14,23,00),time(17,8,00),9.1).
train(messina,cefalu,time(15,46,00),time(18,30,00),9.1).
train(messina,cefalu,time(16,5,00),time(18,0,00),17).
train(messina,cefalu,time(17,25,00),time(20,4,00),9.1).
train(messina,cefalu,time(19,10,00),time(21,15,00),9.1).
train(messina,cefalu,time(19,55,00),time(22,4,00),9.1).

train(messina,palermo,time(6,41,00),time(11,4,00),11.80).
train(messina,palermo,time(11,25,00),time(15,0,00),11.80).
train(messina,palermo,time(12,30,00),time(16,1,00),11.80).
train(messina,palermo,time(14,23,00),time(18,0,00),11.80).
train(messina,palermo,time(15,46,00),time(19,30,00),11.80).
train(messina,palermo,time(16,5,00),time(19,0,00),23).
train(messina,palermo,time(17,25,00),time(21,0,00),11.80).
train(messina,palermo,time(19,10,00),time(22,4,00),11.80).
train(messina,palermo,time(19,55,00),time(23,0,00),11.80).



/* From Cefalu */
train(cefalu,messina,time(6,56,00),time(9,3,00),9.1).
train(cefalu,messina,time(7,58,00),time(10,0,00),17).
train(cefalu,messina,time(8,52,00),time(11,04,00),9.1).
train(cefalu,messina,time(10,8,00),time(12,30,00),9.1).
train(cefalu,messina,time(10,55,00),time(12,55,00),9.1).
train(cefalu,messina,time(12,6,00),time(14,45,00),9.1).
train(cefalu,messina,time(14,1,00),time(16,44,00),9.1).
train(cefalu,messina,time(15,6,00),time(17,20,00),9.1).
train(cefalu,messina,time(16,3,00),time(18,30,00),9.1).
train(cefalu,messina,time(18,4,00),time(20,48,00),9.1).

train(cefalu,palermo,time(6,9,00),time(7,12,00),5.15).
train(cefalu,palermo,time(7,1,00),time(8,0,00),5.15).
train(cefalu,palermo,time(8,5,00),time(9,0,00),5.15).
train(cefalu,palermo,time(9,17,00),time(10,29,00),5.15).
train(cefalu,palermo,time(10,9,00),time(11,4,00),5.15).
train(cefalu,palermo,time(13,7,00),time(14,2,00),5.15).
train(cefalu,palermo,time(14,2,00),time(15,0,00),5.15).
train(cefalu,palermo,time(15,5,00),time(16,1,00),5.15).
train(cefalu,palermo,time(17,9,00),time(18,00,00),5.15).




/* From Catania */
train(catania,messina,time(6,22,00),time(7,52,00),7).
train(catania,messina,time(6,36,00),time(8,21,00),7).
train(catania,messina,time(7,49,00),time(9,20,00),7).
train(catania,messina,time(8,49,00),time(9,56,00),10.50).
train(catania,messina,time(10,0,00),time(11,35,00),7).
train(catania,messina,time(11,12,00),time(12,54,00),7).
train(catania,messina,time(11,37,00),time(13,0,00),7).
train(catania,messina,time(12,24,00),time(14,35,00),7).
train(catania,messina,time(13,2,00),time(15,8,00),7).
train(catania,messina,time(13,56,00),time(15,35,00),7).
train(catania,messina,time(14,23,00),time(16,12,00),7).
train(catania,messina,time(15,46,00),time(17,38,00),7).
train(catania,messina,time(16,20,00),time(18,3,00),7).
train(catania,messina,time(17,44,00),time(19,45,00),7).
train(catania,messina,time(18,36,00),time(20,8,00),7).
train(catania,messina,time(19,39,00),time(21,31,00),7).
train(catania,messina,time(20,46,00),time(22,30,00),7).

train(catania,siracusa,time(6,9,00),time(7,30,00),6.35).
train(catania,siracusa,time(6,50,00),time(8,15,00),6.35).
train(catania,siracusa,time(12,40,00),time(14,5,00),6.35).
train(catania,siracusa,time(14,10,00),time(15,32,00),6.35).
train(catania,siracusa,time(17,22,00),time(18,29,00),9.50).
train(catania,siracusa,time(18,0,00),time(19,18,00),6.35).
train(catania,siracusa,time(19,8,00),time(20,28,00),6.35).
train(catania,siracusa,time(20,13,00),time(21,24,00),6.35).
train(catania,siracusa,time(21,29,00),time(22,45,00),9.50).

train(catania,agrigento,time(14,16,00),time(18,2,00),10.4).
train(catania,aragona,time(14,16,00),time(16,25,00),9.70).
train(catania,roccapalumba,time(9,33,00),time(14,11,00),9.45).


/* From Siracuse */
train(siracusa,noto,time(10,10,00),time(10,39,00),3.45).
train(siracusa,noto,time(12,53,00),time(13,24,00),3.45).
train(siracusa,noto,time(13,58,00),time(14,31,00),3.45).
train(siracusa,noto,time(14,25,00),time(14,57,00),3.45).
train(siracusa,noto,time(16,35,00),time(17,6,00),3.45).
train(siracusa,noto,time(17,35,00),time(18,9,00),3.45).
train(siracusa,noto,time(19,22,00),time(19,53,00),3.45).

train(siracusa,catania,time(6,4,00),time(7,24,00),6.35).
train(siracusa,catania,time(6,32,00),time(7,47,00),6.35).
train(siracusa,catania,time(7,33,00),time(8,40,00),9.50).
train(siracusa,catania,time(8,40,00),time(9,57,00),6.35).
train(siracusa,catania,time(10,25,00),time(1,34,00),9).
train(siracusa,catania,time(13,0,00),time(14,9,00),6.35).
train(siracusa,catania,time(14,26,00),time(15,44,00),6.35).
train(siracusa,catania,time(17,16,00),time(18,33,00),6.35).



/* From Trapani */
train(trapani,palermo,time(6,28,00),time(9,27,00),8).
train(trapani,palermo,time(9,38,00),time(13,27,00),10.4).
train(trapani,palermo,time(16,1,00),time(19,57,00),10.4).
train(trapani,palermo,time(16,22,00),time(19,57,00),8).
train(trapani,palermo,time(18,30,00),time(22,00,00),10.40).





/* From Agrigento */
train(agrigento,catania,time(9,35,00),time(13,22,00),10.40).

train(agrigento,roccapalumba,time(15,14,00),time(16,22,00),5.15).
train(agrigento,roccapalumba,time(4,50,00),time(5,56,00),5.15).

train(agrigento,palermo,time(6,14,00),time(8,24,00),8.30).
train(agrigento,palermo,time(8,14,00),time(10,16,00),8.30).
train(agrigento,palermo,time(10,14,00),time(12,16,00),8.30).
train(agrigento,palermo,time(13,14,00),time(15,16,00),8.30).
train(agrigento,palermo,time(14,14,00),time(16,16,00),8.30).
train(agrigento,palermo,time(15,14,00),time(17,16,00),8.30).
train(agrigento,palermo,time(17,10,00),time(19,20,00),8.30).
train(agrigento,palermo,time(18,14,00),time(20,16,00),8.30).
train(agrigento,palermo,time(20,14,00),time(22,16,00),8.30).



/* From Others */
train(roccapalumba,catania,time(6,15,00),time(8,50,00),9.45).
train(roccapalumba,catania,time(16,59,00),time(19,50,00),9.45).

train(roccapalumba,palermo,time(14,20,00),time(15,15,00),5.15).

train(roccapalumba,agrigento,time(6,45,00),time(7,53,00),5.15).
train(roccapalumba,agrigento,time(8,44,00),time(9,52,00),5.15).
train(roccapalumba,agrigento,time(9,45,00),time(10,52,00),5.15).
train(roccapalumba,agrigento,time(12,45,00),time(13,52,00),5.15).
train(roccapalumba,agrigento,time(14,45,00),time(15,52,00),5.15).
train(roccapalumba,agrigento,time(15,45,00),time(16,58,00),5.15).
train(roccapalumba,agrigento,time(16,42,00),time(17,52,00),5.15).
train(roccapalumba,agrigento,time(17,43,00),time(18,52,00),5.15).
train(roccapalumba,agrigento,time(18,45,00),time(19,52,00),5.15).
train(roccapalumba,agrigento,time(19,45,00),time(21,4,00),5.15).
train(roccapalumba,agrigento,time(21,18,00),time(22,30,00),5.15).

train(aragona,palermo,time(17,29,00),time(19,20,00),8).
train(aragona,catania,time(10,00,00),time(13,22,00),8).


// pulman

pulman(catania,taormina,time(7,0,00),time(8,10,00),5.1).
pulman(catania,taormina,time(7,20,00),time(9,15,00),5).
pulman(catania,taormina,time(9,0,00),time(10,10,00),5.1).
pulman(catania,taormina,time(9,30,00),time(11,40,00),5).
pulman(catania,taormina,time(11,0,00),time(12,10,00),5.1).
pulman(catania,taormina,time(11,30,00),time(13,25,00),5).
pulman(catania,taormina,time(14,0,00),time(15,10,00),5.1).
pulman(catania,taormina,time(17,30,00),time(19,45,00),5).
pulman(catania,taormina,time(18,0,00),time(19,10,00),5.1).
pulman(catania,taormina,time(20,0,00),time(21,10,00),5.1).



pulman(taormina,catania,time(8,45,00),time(10,2,00),5.1).
pulman(taormina,catania,time(10,45,00),time(12,2,00),5.1).
pulman(taormina,catania,time(11,30,00),time(13,25,00),5).
pulman(taormina,catania,time(13,30,00),time(15,25,00),5).
pulman(taormina,catania,time(14,0,00),time(15,17,00),5.1).
pulman(taormina,catania,time(15,30,00),time(17,25,00),5).
pulman(taormina,catania,time(15,45,00),time(17,2,00),5.1).
pulman(taormina,catania,time(17,45,00),time(19,2,00),5.1).


pulman(palermo,siracusa,time(8,00,00),time(11,10,00),13.50).
pulman(palermo,siracusa,time(14,00,00),time(17,10,00),13.50).
pulman(palermo,siracusa,time(18,00,00),time(21,25,00),13.50).

pulman(palermo,catania,time(9,00,00),time(11,30,00),15.50).


