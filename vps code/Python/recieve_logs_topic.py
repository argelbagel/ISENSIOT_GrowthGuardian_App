#!/usr/bin/env python
import pika
import psycopg2
import time

# Make Connection with queue
credentials = pika.PlainCredentials('gebruiker', 'wachtwoord')
parameters = pika.ConnectionParameters('ip-adres',
                                       'poort',
                                       '/',
                                       credentials)

connection = pika.BlockingConnection(parameters)
channel = connection.channel()

# exchange name
channel.exchange_declare(exchange='exchange_naam', exchange_type='topic')

result = channel.queue_declare('', exclusive=True)
queue_name = result.method.queue

binding_keys = ['#']

for binding_key in binding_keys:
    channel.queue_bind(exchange='exchange_naam', queue=queue_name, routing_key=binding_key)

# Make connection with database
conn = psycopg2.connect(
    database="sensordata",
    user="gebruiker",
    password="wachtwoord",
    host="ip-adres")
cur = conn.cursor()


sql = "UPDATE sensordata_table SET id=%s, naam=%s, waterniveau=%s, lichtniveau=%s, temperatuur=%s, bodemvocht=%s, " \
      "luchtvochtigheid=%s, tijd=%s WHERE id=%s;" \
      "INSERT INTO sensordata_table (id, naam, waterniveau, lichtniveau, temperatuur, bodemvocht, " \
      "luchtvochtigheid, tijd) " \
      "SELECT %s,%s,%s,%s,%s,%s,%s,%s WHERE NOT EXISTS (SELECT 1 FROM sensordata_table WHERE id=%s);"


# Print the data from queue
def callback(ch, method, properties, body):
    print(f"{method.routing_key}:{body}")

    decoded_string = body.decode("utf-8")
    data = decoded_string.split(';')
    data[1] = decoded_string.split(',')

    tijd = round(time.time() * 1000)

    lijst_sensordata = [data[1][1], data[0], data[1][3], data[1][5], data[1][7], data[1][9], data[1][11], tijd, data[1][1],
                        data[1][1], data[0], data[1][3], data[1][5], data[1][7], data[1][9], data[1][11], tijd, data[1][1]]

    cur.execute(sql, lijst_sensordata)
    # commit the changes to the database
    conn.commit()


channel.basic_consume(queue=queue_name, on_message_callback=callback, auto_ack=True)
channel.start_consuming()
