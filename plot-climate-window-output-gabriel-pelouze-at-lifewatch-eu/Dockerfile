FROM ghcr.io/qcdis/naavre/naavre-cell-build-lter-life-veluwe:v0.5-alpha.3 AS build
COPY environment.yaml .
RUN micromamba install -y -n venv -f environment.yaml
ARG MAMBA_DOCKERFILE_ACTIVATE=1
USER root
RUN conda-pack -p /venv -o /tmp/env.tar && \
    mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
    rm /tmp/env.tar
RUN /venv/bin/conda-unpack

FROM ghcr.io/qcdis/naavre/naavre-cell-runtime-lter-life-veluwe:v0.5-alpha.3 AS runtime
COPY --from=build /venv /venv
WORKDIR /app
COPY . .