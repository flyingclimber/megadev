FROM amd64/debian
RUN useradd -ms /bin/bash -d /home/megadev megadev

RUN apt-get update
RUN apt-get install -y build-essential wget git texinfo mkisofs

USER megadev
WORKDIR /home/megadev
RUN git clone https://github.com/kentosama/m68k-elf-gcc.git
WORKDIR m68k-elf-gcc
RUN ./build-toolchain.sh
RUN echo export PATH="${PATH}:/opt/m68k-toolchain/bin" >> ~/.bashrc

USER root
WORKDIR /home/megadev/m68k-elf-gcc
RUN cp -R m68k-toolchain /opt

COPY . /opt/megadev
RUN chown -R megadev:megadev /opt/megadev

VOLUME /src
WORKDIR /src

ENV PATH "$PATH:/opt/m68k-toolchain/bin"
ENTRYPOINT ["make"]
