#!/bin/bash

# Credito Claudio
 
# Determinar a último sábado do mês
        #Encontra o último dia do mês (se 28,29,30 ou 31)
        ULTIMO_DIA_MES=$(date -d "`date +%Y%m01` +1 month -1 day" +%Y-%m-%d)
        #Identifica qual dia da semana é o ULTIMO_DIA_MES
        DOW_ULTIMO_DIA=$(date -d ${ULTIMO_DIA_MES} +%w)
        if [ "$DOW_ULTIMO_DIA" == "6" ]
        then
                #Achamos a último sábado
                DATA_ULTIMO_SABADO=$ULTIMO_DIA_MES
        else
                #Localiza o sábado da semana anterior
                DELTA=$(( 6 - $DOW_ULTIMO_DIA ))
                PROX_SABADO=$(date -d "${ULTIMO_DIA_MES} +${DELTA} day" +%Y-%m-%d)
                DATA_ULTIMO_SABADO=$(date -d "${PROX_SABADO} -7 day" +%Y-%m-%d)
        fi
 
DATA_HOJE=`date +%Y-%m-%d`
if [ $DATA_HOJE != $DATA_ULTIMO_SABADO ]
then
  exit 0
else
  echo "Ultimo sabado do mês!"
  echo "Iniciando atualização"
fi
