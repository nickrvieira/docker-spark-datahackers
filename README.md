![DataHackers logo](docs/img/dh_banner.png?raw=true "Data Hackers Logo")

# Data Hackers - Supletivo Apache Spark 

## Intro
:brazil:
Este é um repositório para que você possa compreender um setup básico de um Spark no modo Standalone, bem como explorar um pouco da UI e suas funções mais simples, sem a necessidade de configurar o Spark local em sua máquina.

**PS:** Essa imagem docker foi feita puramente para exploração local/*standalone*, não sendo adequada para o deploy em outros cenários (como K8s)

**ENGLISH DISCLAIMER** :us: *This repo is meant for a Portuguese/BR community - if you have trouble understanding this docs, please open an issue and let me know so I can translate it.*

---
## Setup
Para rodar esse repositório você precisara ter:
- [x] [Docker](https://docs.docker.com/engine/install/)
- [x] [docker-compose](https://docs.docker.com/compose/install/)

Certifique-se que você tem essas dependências antes de prosseguir 
---
## Run

Para iniciar, basta:

```
docker-compose up -d
``` 
(você pode omitir o `-d` para acompanhar o log dos containers)

Para validar - o `docker ps` deverá apresentar algo parecido como:

| CONTAINER ID 	| IMAGE                      	| COMMAND                	| STATUS        	| NAMES         	|
|--------------	|----------------------------	|------------------------	|---------------	|---------------	|
| 726038fdf7b2 	| naniviaa/spark-dhbr:latest 	| "bin/spark-class org…" 	| Up 17 seconds 	| worker-b-dhbr 	|
| 806eef561d69 	| naniviaa/spark-dhbr:latest 	| "bin/spark-class org…" 	| Up 17 seconds 	| worker-a-dhbr 	|
| 3049b4d182d6 	| naniviaa/spark-dhbr:latest 	| "bin/spark-class org…" 	| Up 17 seconds 	| master-dhbr   	|
---
## O que explorar

### **UIs**
O primeiro passo é explorar a Master UI e a Workers' UI:
- Master: http://localhost:8080/
- WorkerA: http://localhost:8081/
- WorkerB: http://localhost:8082/
- Spark Context UI: http://localhost:4040/ - Guarde essa URL para quando submeter um job


#### **Spark Master**

![Spark Master](docs/img/spark_master.png?raw=true "Spark Master")


#### Worker
![Spark Worker](docs/img/spark_worker.png?raw=true "Spark Worker")

---

### Executando Tasks

Para executar tasks nesse modo client:
- É necessário realizar o passo de attach em um dos pods;
- Subir um pod apenas para submissão do job;
- Submeter direto da sua máquina referenciando o ip do pod.

:fireworks: Antes de prosseguir, baixe os dados executando o seguinte script (ou o curl dentro dele): `./download_dataset.sh`

Para facilitar a abordagem, seguiremos pelo *attach* em um dos pods já existentes:
```
docker exec -it master-dhbr bash ./bin/spark-submit --master spark://master:7077 /tmp/app/test_submit.py
```

O arquivo python lê o dataset(csv), adiciona uma nova coluna constante e escreve em disco particionando os dados pela coluna `variety`. Esse script tem um sleep de 5 minutos para que você possa explorar os logs e as organizações do job

:information_source: Aproveite toda informação do Job: Incluindo uso de memória, DAG e como os workers ficaram alocados durante os splits de cada job.


**UI do Job e Overview:**

http://localhost:4040/jobs/

![Visão Geral](docs/img/alocamento_jobs.png?raw=true "Visão Geral")
(Note que o fluxo indica tanto em que momento da timeline os workers foram alocados, como também)


**Stages de execução (lazy):**

http://localhost:4040/stages/
![Job Stages](docs/img/stages.png?raw=true "Job Stages")


**Report DAG ou Query/Execution Plan**:
- http://localhost:4040/SQL/execution/?id=0
- http://localhost:4040/SQL/execution/?id=1


:no_bicycles: **Output do Job**:
Caso você não esteja habituado em persistências em disco com particionamento, dê uma olhada na estrutura criada de CSVs dentro da folder `./output/` e compare como isso difere da inicial presente dentro do `./data`.

:information_source: Volte para as UIs do Master/Workers e observe o que elas contém após a execução

---
### Aprofunde

Aproveite e explore outros scripts - não esqueça sempre de manter:
- Datasets em `./data/`
- Apps em `./app/`
- Escritas em `./output/`
