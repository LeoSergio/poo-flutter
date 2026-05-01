import requests
import os

# Apenas a URL que sabemos que funciona (2024)
urls = {
    "2009": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/861b96a8-5304-4e6a-a8c4-068533ec7cb9/download/discentes-2009.csv",
    "2010": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/5fc61f78-19b4-4020-9f3c-c298cb8a63aa/download/discentes-2010.csv",
    "2011": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/2bb3dec9-7f23-434c-a179-21515f91abc8/download/discentes-2011.csv",
    "2012": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/fc283aa9-61a7-4cf0-91fb-c403c0817b48/download/discentes-2012.csv",
    "2013": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/dba208c2-822f-4e26-adc3-b61d4cb110b6/download/discentes-2013.csv",
    "2014": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/6c23a430-9a7c-4d0f-9602-1d5d97d40e6a/download/discentes-2014.csv",
    "2015": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/e2b5b843-4f58-497e-8979-44daf8df8f94/download/discentes-2015.csv",
    "2016": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/7d2fa5b3-743f-465f-8450-91719b34a002/download/discentes-2016.csv",
    "2017": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/dc732572-a51a-4d4a-a39d-2db37cbe5382/download/discentes-2017.csv",
    "2018": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/146b749b-b9d0-49b2-b114-ac6cc82a4051/download/discentes-2018.csv",
    "2019": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/a55aef81-e094-4267-8643-f283524e3dd7/download/discentes-2019.csv",
    "2020": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/7795c538-86fc-483f-9da9-67b2fcc834ae/download/discentes-2020.csv",
    "2021": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/ac2acdb3-02c0-4334-9865-d384eb2de3b6/download/discentes-2021.csv",
    "2022": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/14afbb6c-395e-411c-b24d-0e494cb95866/download/discentes-2022.csv",
    "2023": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/7c88d1ec-3e83-41b3-9487-c5402fb82c6e/download/discentes-2023.csv",
    "2024": "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/d271d842-929e-4d85-a1a8-c89cbdadb95d/download/discentes-2024.csv"
}


for ano, url in urls.items():
    resposta = requests.get (url)
    if resposta.status_code == 200:
        with open(f"discentes_{ano}.csv", "wb") as f:
            f.write(resposta.content)
        print(f"✅ Baixado: discentes_{ano}.csv")
    else:
        print(f"❌ Erro ao baixar {ano}")




'''
# 2022 (encontrado)
    2022: "https://dados.ufrn.br/dataset/554c2d41-cfce-4278-93c6-eb9aa49c5d16/resource/7c7c7c7c-7c7c-7c7c-7c7c-7c7c7c7c7c7c/download/discentes-2022.csv",
    
    # 2021 (encontrado)
    
    
    

'''