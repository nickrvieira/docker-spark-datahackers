import logging
from time import sleep
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, lit

log = logging.getLogger()


# Gere uma nova Spark Session (que contém um Spark Context + outras coisas)
spark = SparkSession.builder.appName("DataHackers Supletivo").getOrCreate()

# Lê CSV com a opção de headers True - PS: O path se refere ao volume dentro do container
df = spark.read.option("header",True).csv("/tmp/data/iris.csv")

# Crie uma coluna nova
df = df.withColumn("datahackers", lit(True))

# Escreva o CSV particionando por uma coluna
df.write.mode("overwrite").partitionBy("variety").format("csv").save("/tmp/output/job_output.txt")

sleep(60 * 5)  # Sleep por 5 minutos para você poder explorar a UI
# Explore a UI em localhost:4040

# Encerra Session e Contexto (Esse comendo suspende a UI)
spark.stop()
