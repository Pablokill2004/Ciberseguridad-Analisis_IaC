# Imagen de demostracion para el analisis de seguridad IaC.
# ESTADO: REMEDIADO (PR de correccion).

FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --uid 10001 appuser

COPY app.sh /usr/local/bin/app.sh
RUN chmod 0755 /usr/local/bin/app.sh

USER appuser

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD test -f /usr/local/bin/app.sh || exit 1

CMD ["/usr/local/bin/app.sh"]
