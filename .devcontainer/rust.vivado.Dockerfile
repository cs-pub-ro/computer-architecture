# Thin wrapper used for adding the rust toolchain
FROM gitlab.cs.pub.ro:5050/ac/ac-public/vivado-slim:1.0.0

# install rust for didactic assembler
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
