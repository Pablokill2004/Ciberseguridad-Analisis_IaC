# Imagen de demostracion para el analisis de seguridad IaC.
# ESTADO: LINEA BASE INSEGURA (a proposito).
# Los hallazgos se corrigen en el PR de remediacion.

FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl

COPY app.sh /usr/local/bin/app.sh
RUN chmod +x /usr/local/bin/app.sh

CMD ["/usr/local/bin/app.sh"]
